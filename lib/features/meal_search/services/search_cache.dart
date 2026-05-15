import 'package:hive_flutter/hive_flutter.dart';
import '../models/cached_search_result.dart';

class SearchCache {
  static const String _boxName = 'search_cache';

  static Future<void> init() async {
    Hive.registerAdapter(CachedSearchResultAdapter());
    await Hive.openBox<CachedSearchResult>(_boxName);
  }

  static Future<void> saveSearch(String query, List<String> resultNames) async {
    final box = Hive.box<CachedSearchResult>(_boxName);
    final cached = CachedSearchResult(
      query: query.toLowerCase().trim(),
      resultNames: resultNames,
      timestamp: DateTime.now(),
    );
    await box.put(query.toLowerCase().trim(), cached);
  }

  static List<String>? getCachedResults(String query) {
    final box = Hive.box<CachedSearchResult>(_boxName);
    final cached = box.get(query.toLowerCase().trim());

    if (cached == null) return null;

    // Cache expires after 7 days
    if (DateTime.now().difference(cached.timestamp).inDays > 7) {
      box.delete(query.toLowerCase().trim());
      return null;
    }

    return cached.resultNames;
  }
}