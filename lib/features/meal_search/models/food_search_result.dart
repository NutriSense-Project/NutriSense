// lib/features/meal_search/models/food_search_result.dart
class FoodSearchResult {
  final String id;
  final String name;
  final String? imageUrl;
  final double? amount;           // e.g., 100.0
  final String? unit;             // e.g., "g", "cup", "piece"
  final double? calories;
  final String? spoonacularCategory;

  FoodSearchResult({
    required this.id,
    required this.name,
    this.imageUrl,
    this.amount,
    this.unit,
    this.calories,
    this.spoonacularCategory,
  });
}