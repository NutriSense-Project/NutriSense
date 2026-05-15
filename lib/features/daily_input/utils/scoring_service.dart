import '../../../data/models/food_groups.dart';

class ScoringService {
  static int calculateScore(Map<String, int> servings) {
    double score = 45.0;

    // Adequacy groups
    for (var group in allFoodGroups.where((g) => g.category == FoodCategory.adequacy)) {
      final intake = servings[group.id] ?? 0;
      if (intake == 0) continue;

      double multiplier = 1.0;
      if (group.id.contains('vegetables') || group.id.contains('greens')) multiplier = 1.4;
      if (group.id == 'whole_grains') multiplier = 1.25;

      score += (intake * group.weight * multiplier).clamp(0, 35);
    }

    // Moderation groups
    for (var group in allFoodGroups.where((g) => g.category == FoodCategory.moderation)) {
      final intake = servings[group.id] ?? 0;
      if (intake == 0) continue;

      double penalty = intake * group.weight * 0.95;
      if (intake >= 3) penalty *= 1.6;

      score -= penalty.clamp(0, 35);
    }

    // Diversity bonus
    if (servings.length >= 6) score += 8;
    if (servings.length >= 8) score += 5;

    return score.clamp(0, 100).round();
  }

  /// Suggestions ordered by priority (highest weight first)
  static List<String> getSuggestions(Map<String, int> servings) {
    final score = calculateScore(servings);
    final List<String> suggestions = [];

    // Excellent / Good scores → Positive message only
    if (score >= 85) {
      return ["Outstanding day! You're eating very well 💪"];
    }
    if (score >= 70) {
      return ["Good job today! Keep building on this."];
    }

    // === Priority 1: Missing High-Weight Adequacy Groups ===
    final missingHighPriority = allFoodGroups
        .where((g) => g.category == FoodCategory.adequacy && g.weight >= 12)
        .where((g) => (servings[g.id] ?? 0) == 0)
        .toList()
      ..sort((a, b) => b.weight.compareTo(a.weight)); // Highest weight first

    for (var group in missingHighPriority.take(2)) {
      suggestions.add("High priority: Add more ${group.name.toLowerCase()} today.");
    }

    // === Priority 2: Missing Medium-Weight Adequacy Groups ===
    final missingMedium = allFoodGroups
        .where((g) => g.category == FoodCategory.adequacy && g.weight >= 10)
        .where((g) => (servings[g.id] ?? 0) == 0)
        .where((g) => !missingHighPriority.contains(g))
        .toList()
      ..sort((a, b) => b.weight.compareTo(a.weight));

    for (var group in missingMedium.take(1)) {
      suggestions.add("Good to add: ${group.name.toLowerCase()}.");
    }

    // === Priority 3: Moderation Warnings ===
    final excessiveModeration = allFoodGroups
        .where((g) => g.category == FoodCategory.moderation)
        .where((g) => (servings[g.id] ?? 0) >= 2)
        .toList()
      ..sort((a, b) => b.weight.compareTo(a.weight)); // Most harmful first

    for (var group in excessiveModeration.take(1)) {
      suggestions.add("Try reducing ${group.name.toLowerCase()} today.");
    }

    // Fallback
    if (suggestions.isEmpty) {
      suggestions.add(servings.isEmpty 
          ? "Start by logging some fruits or vegetables" 
          : "Try increasing variety in your food groups");
    }

    return suggestions;
  }
}