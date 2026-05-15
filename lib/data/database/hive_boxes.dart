import 'package:hive_flutter/hive_flutter.dart';
import '../models/daily_entry.dart';

class HiveBoxes {
  static const String dailyEntries = 'daily_entries';

  static Future<void> init() async {
    Hive.registerAdapter(DailyEntryAdapter());
    await Hive.openBox<DailyEntry>(dailyEntries);
  }
}