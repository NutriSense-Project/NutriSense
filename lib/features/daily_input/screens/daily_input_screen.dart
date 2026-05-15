import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../daily_input/providers/daily_input_provider.dart';
import '../../meal_search/screens/meal_search_screen.dart';
import '../widgets/food_group_grid.dart';
import '../widgets/daily_summary.dart';
import '../widgets/suggestions_section.dart';

class DailyInputScreen extends ConsumerWidget {
  final DateTime? selectedDate;

  const DailyInputScreen({super.key, this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetDate = selectedDate ?? DateTime.now();

    final isToday = targetDate.year == DateTime.now().year &&
        targetDate.month == DateTime.now().month &&
        targetDate.day == DateTime.now().day;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isToday ? "Today's Intake" : "Intake - ${targetDate.toIso8601String().split('T').first}",
        ),
        leading: context.canPop()
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())
            : null,
      ),
      body: Column(
        children: [
          DailySummaryCard(selectedDate: targetDate),   // Save button will be inside
          Expanded(child: FoodGroupGrid(selectedDate: targetDate)),
          SuggestionsSection(selectedDate: targetDate),
        ],
      ),
    );
  }
}