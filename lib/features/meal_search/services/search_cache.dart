import 'package:hive_flutter/hive_flutter.dart';
import '../models/cached_search_result.dart';

class SearchCache {
  static const String _searchBoxName = 'search_cache';
  static const String _userCorrectionsBox = 'user_corrections';

  static Future<void> init() async {
    Hive.registerAdapter(CachedSearchResultAdapter());
    await Hive.openBox<CachedSearchResult>(_searchBoxName);
    await Hive.openBox<String>(_userCorrectionsBox);
  }

  static Future<void> saveSearch(String query, List<String> resultNames) async {
    final box = Hive.box<CachedSearchResult>(_searchBoxName);
    final cached = CachedSearchResult(
      query: query.toLowerCase().trim(),
      resultNames: resultNames,
      timestamp: DateTime.now(),
    );
    await box.put(query.toLowerCase().trim(), cached);
  }

  static List<String>? getCachedResults(String query) {
    final box = Hive.box<CachedSearchResult>(_searchBoxName);
    final cached = box.get(query.toLowerCase().trim());

    if (cached == null) return null;

    if (DateTime.now().difference(cached.timestamp).inDays > 14) {
      box.delete(query.toLowerCase().trim());
      return null;
    }

    return cached.resultNames;
  }

  static Future<void> saveUserCorrection(String foodName, String groupId) async {
    final box = Hive.box<String>(_userCorrectionsBox);
    await box.put(foodName.toLowerCase().trim(), groupId);
    print("🎓 Learned correction: $foodName → $groupId");
  }

  static String? getUserCorrection(String foodName) {
    final box = Hive.box<String>(_userCorrectionsBox);
    return box.get(foodName.toLowerCase().trim());
  }

  static Future<void> clearOldCache() async {
    final box = Hive.box<CachedSearchResult>(_searchBoxName);
    await box.clear();
  }
}