enum FoodCategory { adequacy, moderation }

class FoodGroup {
  final String id;
  final String name;
  final FoodCategory category;
  final String emoji;
  final String servingHint;
  final int weight; // Higher = more important for scoring

  const FoodGroup({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.servingHint,
    this.weight = 10,
  });
}

// ====================== ALL FOOD GROUPS (Single Source of Truth) ======================
final List<FoodGroup> allFoodGroups = [
  // === Adequacy (Encourage) ===
  FoodGroup(
    id: 'fruits',
    name: 'Fruits',
    category: FoodCategory.adequacy,
    emoji: '🍎',
    servingHint: '1 cup / 1 medium piece',
    weight: 12,
  ),
  FoodGroup(
    id: 'starchy_vegetables',
    name: 'Starchy Vegetables',
    category: FoodCategory.adequacy,
    emoji: '🥔',
    servingHint: '1 cup raw / ½ cup cooked',
    weight: 12,
  ),
  FoodGroup(
    id: 'protein',
    name: 'Saturated Fat',
    category: FoodCategory.moderation,
    emoji: '🍗',
    servingHint: 'Fried & fatty foods',
    weight: 10,
  ),
  FoodGroup(
    id: 'greens_beans',
    name: 'Greens & Beans',
    category: FoodCategory.adequacy,
    emoji: '🥬',
    servingHint: '½ cup',
    weight: 14,
  ),
  FoodGroup(
    id: 'whole_grains',
    name: 'Whole Grains',
    category: FoodCategory.adequacy,
    emoji: '🌾',
    servingHint: '½ cup cooked',
    weight: 13,
  ),
  FoodGroup(
    id: 'dairy',
    name: 'Dairy',
    category: FoodCategory.adequacy,
    emoji: '🥛',
    servingHint: '1 cup',
    weight: 10,
  ),
  FoodGroup(
    id: 'seafood_nuts',
    name: 'Seafood & Nuts',
    category: FoodCategory.adequacy,
    emoji: '🐟',
    servingHint: '100g / handful nuts',
    weight: 12,
  ),

  // === Moderation (Limit) ===
  FoodGroup(
    id: 'added_sugars',
    name: 'Added Sugars',
    category: FoodCategory.moderation,
    emoji: '🍭',
    servingHint: 'Sweets, Juices & sodas',
    weight: 13,
  ),
  FoodGroup(
    id: 'sodium',
    name: 'Sodium',
    category: FoodCategory.moderation,
    emoji: '🧂',
    servingHint: 'Processed food with extra salt',
    weight: 11,
  ),
  FoodGroup(
    id: 'saturated_fat',
    name: 'Saturated Fat',
    category: FoodCategory.moderation,
    emoji: '🍗',
    servingHint: 'Fried & fatty foods',
    weight: 10,
  ),
];
