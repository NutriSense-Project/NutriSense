import 'package:flutter/material.dart';
import '../../../data/models/daily_entry.dart';
import '../utils/streak_service.dart';

class StatsSummaryCard extends StatelessWidget {
  final List<DailyEntry> entries;

  const StatsSummaryCard({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text("Start logging days to see statistics")),
        ),
      );
    }

    // Filter only days with actual food entries
    final activeEntries = entries.where((e) => e.servings.isNotEmpty).toList();

    final int totalDays = entries.length;
    final int activeDays = activeEntries.length;

    final scores = activeEntries.map((e) => e.score).toList();
    final avgScore = scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) ~/ scores.length;
    final bestScore = scores.isEmpty ? 0 : scores.reduce((a, b) => a > b ? a : b);
    final streak = StreakService.calculateCurrentStreak(entries);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  "Avg Score",
                  scores.isEmpty ? "-" : avgScore.toString(),
                  Colors.blue,
                ),
                _buildStatColumn(
                  "Best Score",
                  bestScore.toString(),
                  Colors.green,
                ),
                _buildStatColumn(
                  "Active Days",
                  "$activeDays/$totalDays",
                  Colors.purple,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Current Streak: $streak days",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (activeDays < totalDays)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Average calculated from $activeDays days with logged food",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}