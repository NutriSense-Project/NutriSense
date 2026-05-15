import '../../../data/models/food_groups.dart';
import '../models/food_search_result.dart';

class FoodMapper {
  /// Main mapping function: Spoonacular result → Your FoodGroup + suggested servings
  static Map<String, dynamic> mapToFoodGroup(FoodSearchResult result) {
    final nameLower = result.name.toLowerCase();

    // Try direct keyword matching (highest priority)
    for (var group in allFoodGroups) {
      final groupNameLower = group.name.toLowerCase();

      if (nameLower.contains(groupNameLower) || 
          groupNameLower.contains(nameLower.split(' ').first)) {
        
        return {
          'foodGroup': group,
          'suggestedServings': _estimateServings(result, group),
          'confidence': 0.9,
        };
      }
    }

    // Category-based fallback
    if (nameLower.contains('chicken') || 
        nameLower.contains('beef') || 
        nameLower.contains('fish') || 
        nameLower.contains('egg')) {
      return {
        'foodGroup': allFoodGroups.firstWhere((g) => g.id == 'total_protein'),
        'suggestedServings': 1,
        'confidence': 0.7,
      };
    }

    if (nameLower.contains('rice') || nameLower.contains('bread') || nameLower.contains('oat')) {
      return {
        'foodGroup': allFoodGroups.firstWhere((g) => g.id == 'whole_grains'),
        'suggestedServings': 1,
        'confidence': 0.75,
      };
    }

    if (nameLower.contains('broccoli') || 
        nameLower.contains('carrot') || 
        nameLower.contains('salad')) {
      return {
        'foodGroup': allFoodGroups.firstWhere((g) => g.id == 'vegetables'),
        'suggestedServings': 2,
        'confidence': 0.85,
      };
    }

    // Default fallback
    return {
      'foodGroup': allFoodGroups.firstWhere((g) => g.id == 'total_fruits'), // safe default
      'suggestedServings': 1,
      'confidence': 0.4,
    };
  }

  static int _estimateServings(FoodSearchResult result, FoodGroup group) {
    if (result.amount == null) return 1;

    // Simple heuristic based on amount and unit
    if (result.unit == 'g' || result.unit == 'gram') {
      if (result.amount! > 200) return 2;
      if (result.amount! > 100) return 1;
    }

    return 1; // default
  }
}