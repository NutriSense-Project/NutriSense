import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daily_input_provider.dart';
import 'package:nutrisense/core/widgets/pop_button.dart';
import 'package:nutrisense/core/widgets/animated_top_snackbar.dart';

class DailySummaryCard extends ConsumerWidget {
  final DateTime selectedDate;

  const DailySummaryCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(currentDailyEntryProvider(selectedDate));
    final score = entry.score;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 78,
                      height: 78,
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 8,
                        backgroundColor: theme.brightness == Brightness.dark 
                            ? Colors.grey.shade800 
                            : Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(
                          score >= 75 ? Colors.green : score >= 50 ? Colors.orange : Colors.red,
                        ),
                      ),
                    ),
                    Text(
                      score.toString(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (selectedDate.year == DateTime.now().year && 
                         selectedDate.month == DateTime.now().month && 
                         selectedDate.day == DateTime.now().day)
                            ? "Today's Score"
                            : "Score for ${selectedDate.toIso8601String().split('T').first}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getScoreMessage(score),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "${entry.servings.length} food groups logged",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            PopButton(
              onPressed: () async {
                await ref.read(currentDailyEntryProvider(selectedDate).notifier).save();
                if (context.mounted) {
                  AnimatedTopSnackBar.show(context, '✅ Day saved successfully!');
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text("Save Day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return "Excellent work today!";
    if (score >= 65) return "Good progress!";
    if (score >= 45) return "Room for improvement";
    return "Let's add more healthy foods";
  }
}