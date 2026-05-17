import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daily_input_provider.dart';
import '../utils/scoring_service.dart';
import '../../meal_search/screens/meal_search_screen.dart';
import '../../../core/widgets/pop_button.dart';

class SuggestionsSection extends ConsumerWidget {
  final DateTime selectedDate;

  const SuggestionsSection({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(currentDailyEntryProvider(selectedDate));
    final suggestions = ScoringService.getSuggestions(entry.servings);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    "Suggestions",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              PopButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealSearchScreen(selectedDate: selectedDate),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 6),
                    Text("Log a Meal"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (suggestions.isNotEmpty)
            ...suggestions.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Great job! Keep logging your meals.",
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}