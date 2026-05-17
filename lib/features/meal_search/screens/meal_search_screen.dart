import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrisense/core/widgets/animated_top_snackbar.dart';
import '../../../data/models/food_groups.dart';
import '../../../features/daily_input/providers/daily_input_provider.dart';
import '../services/common_foods.dart';

class MealSearchScreen extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const MealSearchScreen({super.key, required this.selectedDate});

  @override
  ConsumerState<MealSearchScreen> createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends ConsumerState<MealSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _displayedFoods = [];

  @override
  void initState() {
    super.initState();
    _displayedFoods = CommonFoods.getCommonFoodNames();
  }

  void _updateSuggestions(String query) {
    if (query.trim().isEmpty) {
      setState(() => _displayedFoods = CommonFoods.getCommonFoodNames());
      return;
    }

    final queryLower = query.toLowerCase().trim();

    final matches = CommonFoods.getCommonFoodNames().where((name) {
      return name.toLowerCase().contains(queryLower);
    }).toList();

    setState(() => _displayedFoods = matches);
  }

  void _selectFood(String foodName) {
    final foodGroup = CommonFoods.getFoodGroup(foodName);
    if (foodGroup == null) return;

    showDialog(
      context: context,
      builder: (context) => ServingPickerDialog(
        foodName: foodName,
        foodGroup: foodGroup,
        onConfirm: (servings) {
          _addToDailyLog(foodName, foodGroup, servings);
        },
      ),
    );
  }

  void _addToDailyLog(String foodName, FoodGroup group, int servings) {
    ref.read(currentDailyEntryProvider(widget.selectedDate).notifier)
        .updateServing(group.id, servings);

    Navigator.pop(context);

    AnimatedTopSnackBar.show(context, '✅ Added $foodName ($servings servings)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log a Meal'), animateColor: true,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search food (chicken, banana, rice...)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _updateSuggestions,
            ),
          ),

          Expanded(
            child: _displayedFoods.isEmpty
                ? const Center(child: Text("No matching foods found"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _displayedFoods.length,
                    itemBuilder: (context, index) {
                      final foodName = _displayedFoods[index];
                      final foodGroup = CommonFoods.getFoodGroup(foodName);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Text(
                            foodGroup?.emoji ?? '🍽️',
                            style: const TextStyle(fontSize: 32),
                          ),
                          title: Text(foodName[0].toUpperCase() + foodName.substring(1)),
                          subtitle: Text(foodGroup?.name ?? ''),
                          trailing: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onTap: () => _selectFood(foodName),
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

// Serving Picker Dialog with Slider (Max 10)
class ServingPickerDialog extends StatefulWidget {
  final String foodName;
  final FoodGroup foodGroup;
  final Function(int servings) onConfirm;

  const ServingPickerDialog({
    super.key,
    required this.foodName,
    required this.foodGroup,
    required this.onConfirm,
  });

  @override
  State<ServingPickerDialog> createState() => _ServingPickerDialogState();
}

class _ServingPickerDialogState extends State<ServingPickerDialog> {
  int _servings = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(widget.foodGroup.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Text(
            widget.foodName[0].toUpperCase() + widget.foodName.substring(1),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$_servings serving${_servings > 1 ? 's' : ''}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _servings.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _servings.toString(),
            onChanged: (value) {
              setState(() => _servings = value.round());
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("1"),
              Text("10"),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onConfirm(_servings);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}