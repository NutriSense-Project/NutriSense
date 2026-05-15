import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/food_groups.dart';

class FoodCache {
  static const String _commonFoodsBox = 'common_foods';

  // Pre-mapped common foods (fastest path)
  static final Map<String, FoodGroup> _commonFoodMap = {
    'apple': allFoodGroups.firstWhere((g) => g.id == 'fruits'),
    'banana': allFoodGroups.firstWhere((g) => g.id == 'fruits'),
    'chicken': allFoodGroups.firstWhere((g) => g.id == 'protein'),
    'rice': allFoodGroups.firstWhere((g) => g.id == 'whole_grains'),
    'broccoli': allFoodGroups.firstWhere((g) => g.id == 'vegetables'),
  };

  static FoodGroup? getCachedGroup(String foodName) {
    final lower = foodName.toLowerCase();
    for (var entry in _commonFoodMap.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }
}