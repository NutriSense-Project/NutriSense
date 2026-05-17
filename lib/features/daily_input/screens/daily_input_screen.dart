import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/food_group_grid.dart';
import '../widgets/daily_summary.dart';
import '../widgets/suggestions_section.dart';

class DailyInputScreen extends ConsumerWidget {
  final DateTime? selectedDate;

  const DailyInputScreen({super.key, this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetDate = selectedDate ?? DateTime.now();

    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20),child: DailySummaryCard(selectedDate: targetDate)),   // Save button will be inside
          Expanded(child: FoodGroupGrid(selectedDate: targetDate)),
          SuggestionsSection(selectedDate: targetDate),
        ],
      ),
      floatingActionButton: Navigator.canPop(context)
        ? FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left),
          )
        : null, // Button is hidden on the home screen
      );
  }
}