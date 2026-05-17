import 'package:flutter/material.dart';
import '../../../data/models/daily_entry.dart';
import '../utils/streak_service.dart';

class StreakCard extends StatelessWidget {
  final List<DailyEntry> entries;

  const StreakCard({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final streak = StreakService.calculateCurrentStreak(entries);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, size: 60, color: Colors.orange),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Streak",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "$streak days",
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  streak >= 7 ? "Amazing consistency!" : "Keep the momentum going!",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}