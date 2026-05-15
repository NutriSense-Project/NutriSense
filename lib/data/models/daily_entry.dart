import 'package:hive/hive.dart';
import 'food_groups.dart';

part 'daily_entry.g.dart';

@HiveType(typeId: 1)
class DailyEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final Map<String, int> servings;

  @HiveField(3)
  final int score;

  DailyEntry({
    required this.id,
    required this.date,
    required this.servings,
    required this.score,
  });

  DailyEntry copyWith({
    Map<String, int>? servings,
    int? score,
  }) {
    return DailyEntry(
      id: id,
      date: date,
      servings: servings ?? this.servings,
      score: score ?? this.score,
    );
  }
}