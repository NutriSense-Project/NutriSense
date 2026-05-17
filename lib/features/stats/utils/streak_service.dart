import '../../../data/models/daily_entry.dart';

class StreakService {
  static int calculateCurrentStreak(List<DailyEntry> entries) {
    if (entries.isEmpty) return 0;

    final dates = entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();

    int streak = 0;
    DateTime current = DateTime.now();

    while (true) {
      final normalized = DateTime(current.year, current.month, current.day);
      if (dates.contains(normalized)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}