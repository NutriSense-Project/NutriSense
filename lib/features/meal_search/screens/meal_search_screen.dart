import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/food_groups.dart';
import '../../../features/daily_input/providers/daily_input_provider.dart';
import '../models/food_search_result.dart';
import '../services/spoonacular_service.dart';
import '../services/food_mapper.dart';
import '../services/search_cache.dart';

class MealSearchScreen extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const MealSearchScreen({super.key, required this.selectedDate});

  @override
  ConsumerState<MealSearchScreen> createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends ConsumerState<MealSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SpoonacularService _spoonacularService = SpoonacularService(
    "fb0dcbbafb254223b33ab729f2cf0a03",
  );

  List<FoodSearchResult> _results = [];
  bool _isLoading = false;
  String? _error;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 450), () {
      final query = _searchController.text.trim();
      if (query.length >= 2) {
        _performSearch(query);
      } else {
        setState(() => _results = []);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);

    // 1. Check cache first
    final cachedNames = SearchCache.getCachedResults(query);
    if (cachedNames != null) {
      // Convert cached names back to dummy results for display
      setState(() {
        _results = cachedNames.map((name) => FoodSearchResult(
              id: name,
              name: name,
            )).toList();
        _isLoading = false;
      });
      return;
    }

    // 2. Call API if not cached
    try {
      final apiResults = await _spoonacularService.searchFood(query);

      // Save to cache
      await SearchCache.saveSearch(query, apiResults.map((r) => r.name).toList());

      if (mounted) {
        setState(() {
          _results = apiResults;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Failed to fetch results";
          _isLoading = false;
        });
      }
    }
  }

  void _addToDailyLog(FoodSearchResult result) {
    final mapping = FoodMapper.mapToFoodGroup(result);
    final FoodGroup foodGroup = mapping['foodGroup'];
    final int suggestedServings = mapping['suggestedServings'];

    ref.read(currentDailyEntryProvider(widget.selectedDate).notifier)
        .updateServing(foodGroup.id, suggestedServings);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${result.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log a Meal')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: "Search food (e.g. grilled chicken, banana, oatmeal)",
              leading: const Icon(Icons.search),
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),

          Expanded(
            child: _results.isEmpty && !_isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("Type to search meals or ingredients"),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      final mapping = FoodMapper.mapToFoodGroup(item);
                      final FoodGroup group = mapping['foodGroup'];
                      final int servings = mapping['suggestedServings'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: Text(group.emoji, style: const TextStyle(fontSize: 26)),
                          ),
                          title: Text(item.name),
                          subtitle: Text(
                            "${group.name} • Suggested: $servings serving${servings > 1 ? 's' : ''}",
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                          trailing: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onTap: () => _addToDailyLog(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}