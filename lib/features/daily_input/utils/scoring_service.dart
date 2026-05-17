import '../../../data/models/food_groups.dart';

class ScoringService {

  static int calculateScore(Map<String, int> servings) {
    double score = 45.0;

    for (var group in allFoodGroups.where((g) => g.category == FoodCategory.adequacy)) {
      final intake = servings[group.id] ?? 0;
      if (intake == 0) continue;

      double multiplier = 1.0;
      if (group.id == 'vegetables' || group.id == 'greens_beans') multiplier = 1.45;
      if (group.id == 'whole_grains') multiplier = 1.3;
      if (group.id == 'seafood_plant_protein') multiplier = 1.25;

      double effectiveIntake = intake.toDouble();
      if (intake > 3) {
        effectiveIntake = 3 + (intake - 3) * 0.45;
      }

      score += (effectiveIntake * group.weight * multiplier).clamp(0, 42);
    }

    for (var group in allFoodGroups.where((g) => g.category == FoodCategory.moderation)) {
      final intake = servings[group.id] ?? 0;
      if (intake == 0) continue;

      double penalty = intake * group.weight * 1.15;

      if (intake >= 4) penalty *= 1.7;     
      else if (intake >= 2) penalty *= 1.3;

      score -= penalty.clamp(0, 45);
    }

    final uniqueGroups = servings.length;
    if (uniqueGroups >= 5) score += 8;
    if (uniqueGroups >= 7) score += 5;
    if (uniqueGroups >= 9) score += 4;

    return score.clamp(0, 100).round();
  }

  static List<String> getSuggestions(Map<String, int> servings) {
    //final score = calculateScore(servings);
    final suggestions = <String>[];

    //if (score >= 85) {
    //  return ["Outstanding day! You're eating very well"];
    //}

    final missingHigh = allFoodGroups
        .where((g) => g.category == FoodCategory.adequacy && g.weight >= 12)
        .where((g) => (servings[g.id] ?? 0) == 0)
        .take(2);

    for (var group in missingHigh) {
      suggestions.add("High priority: Add more ${group.name.toLowerCase()}.");
    }

    final excessive = allFoodGroups
        .where((g) => g.category == FoodCategory.moderation)
        .where((g) => (servings[g.id] ?? 0) >= 2)
        .take(1);

    for (var group in excessive) {
      if (group.id == 'refined_grains') {
        suggestions.add("Try eating high-fiber foods such as whole grains.");
      } else {
        suggestions.add("Try reducing ${group.name.toLowerCase()}.");
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add("Try increasing variety across food groups.");
    }

    return suggestions;
  }
}