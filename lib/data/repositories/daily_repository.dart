import 'package:hive_flutter/hive_flutter.dart';
import '../models/daily_entry.dart';
import '../database/hive_boxes.dart';

class DailyRepository {
  static const String _boxName = HiveBoxes.dailyEntries;
  Box<DailyEntry>? _box;

  Future<Box<DailyEntry>> get _hiveBox async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await Hive.openBox<DailyEntry>(_boxName);
    return _box!;
  }

  Future<DailyEntry?> getEntryForDate(DateTime date) async {
    final box = await _hiveBox;
    final key = _getKey(date);

    try {
      return box.get(key);
    } catch (e) {
      print("Error getting entry for $key: $e");
      return null;
    }
  }

  Future<void> saveEntry(DailyEntry entry) async {
    final box = await _hiveBox;
    final key = entry.id;

    await box.put(key, entry);

    if (box.length % 30 == 0) {
      await _compactIfNeeded(box);
    }
  }

  Future<List<DailyEntry>> getAllEntries() async {
    final box = await _hiveBox;
    final entries = box.values.toList();

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<List<DailyEntry>> getEntriesForMonth(int year, int month) async {
    final box = await _hiveBox;
    final entries = box.values.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> clearAllData() async {
    final box = await _hiveBox;
    await box.clear();
    print("Hive box cleared successfully");
  }

  Future<void> _compactIfNeeded(Box<DailyEntry> box) async {
    try {
      if (box.length > 50) {
        await box.compact();
        print("Hive box compacted");
      }
    } catch (e) {
      print("Compact failed: $e");
    }
  }

  String _getKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> close() async {
    if (_box?.isOpen == true) {
      await _box!.close();
      _box = null;
    }
  }
}