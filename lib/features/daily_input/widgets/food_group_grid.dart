import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/food_groups.dart';
import '../providers/daily_input_provider.dart';
import 'serving_selector.dart';

class FoodGroupGrid extends ConsumerWidget {
  final DateTime selectedDate;

  const FoodGroupGrid({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final crossAxisCount = width > 800 ? 4 : width > 600 ? 3 : 2;
        final childAspectRatio = height < 700 ? 1.05 : 1.22;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allFoodGroups.length,
          itemBuilder: (context, index) {
            final group = allFoodGroups[index];

            final currentServings = ref.watch(
              currentDailyEntryProvider(selectedDate).select(
                (entry) => entry.servings[group.id] ?? 0,
              ),
            );

            final isLogged = currentServings > 0;
            final theme = Theme.of(context);

            return Card(
              elevation: isLogged ? 3 : 1.5,
              color: isLogged
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.8)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: isLogged
                    ? BorderSide(color: theme.colorScheme.primary, width: 2)
                    : BorderSide.none,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _showServingSelector(context, group, ref, currentServings),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji
                      Text(
                        group.emoji,
                        style: const TextStyle(fontSize: 34),
                      ),

                      const SizedBox(height: 6),

                      Expanded(
                        child: Center(
                          child: Text(
                            group.name,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              fontSize: 13.8,        
                              height: 1.05,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: isLogged
                              ? theme.colorScheme.primary.withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '$currentServings servings',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: isLogged
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showServingSelector(BuildContext context, FoodGroup group, WidgetRef ref, int current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => ServingSelectorBottomSheet(
        group: group,
        currentServings: current,
        onChanged: (newValue) {
          ref.read(currentDailyEntryProvider(selectedDate).notifier)
              .updateServing(group.id, newValue);
        },
      ),
    );
  }
}