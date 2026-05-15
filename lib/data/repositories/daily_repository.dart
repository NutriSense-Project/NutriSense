import 'package:hive_flutter/hive_flutter.dart';
import '../models/daily_entry.dart';
import '../database/hive_boxes.dart';

class DailyRepository {
  static const String _boxName = HiveBoxes.dailyEntries;
  Box<DailyEntry>? _box;

  // Lazy initialization + keep box open
  Future<Box<DailyEntry>> get _hiveBox async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await Hive.openBox<DailyEntry>(_boxName);
    return _box!;
  }

  /// Get entry for a specific date (Very fast lookup)
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

  /// Save or update entry
  Future<void> saveEntry(DailyEntry entry) async {
    final box = await _hiveBox;
    final key = entry.id; // We already use date string as key

    await box.put(key, entry);

    // Periodic compaction for performance
    if (box.length % 30 == 0) {
      await _compactIfNeeded(box);
    }
  }

  /// Get all entries (sorted by date - newest first)
  Future<List<DailyEntry>> getAllEntries() async {
    final box = await _hiveBox;
    final entries = box.values.toList();

    // Sort by date descending (newest first)
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// Get entries for a specific month (Useful for stats)
  Future<List<DailyEntry>> getEntriesForMonth(int year, int month) async {
    final box = await _hiveBox;
    final entries = box.values.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// Clear all data
  Future<void> clearAllData() async {
    final box = await _hiveBox;
    await box.clear();
    print("🗑️ Hive box cleared successfully");
  }

  /// Compact the box to optimize storage and performance
  Future<void> _compactIfNeeded(Box<DailyEntry> box) async {
    try {
      if (box.length > 50) {
        await box.compact();
        print("🔧 Hive box compacted for better performance");
      }
    } catch (e) {
      print("Compact failed: $e");
    }
  }

  /// Generate consistent key from date
  String _getKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Close the box when app is backgrounded (optional optimization)
  Future<void> close() async {
    if (_box?.isOpen == true) {
      await _box!.close();
      _box = null;
    }
  }
}