import 'package:hive/hive.dart';

part 'cached_search_result.g.dart';

@HiveType(typeId: 2)
class CachedSearchResult {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final List<String> resultNames;

  @HiveField(2)
  final DateTime timestamp;

  CachedSearchResult({
    required this.query,
    required this.resultNames,
    required this.timestamp,
  });
}