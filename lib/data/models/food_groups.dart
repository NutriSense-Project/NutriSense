enum FoodCategory { adequacy, moderation }

class FoodGroup {
  final String id;
  final String name;
  final FoodCategory category;
  final String emoji;
  final String servingHint;
  final int weight;
  final String? description;

  const FoodGroup({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.servingHint,
    this.weight = 10,
    this.description,
  });
}

final List<FoodGroup> allFoodGroups = [
  // === Adequacy (Encourage) ===
  FoodGroup(
    id: 'fruits',
    name: 'Fruits',
    category: FoodCategory.adequacy,
    emoji: '🍎',
    servingHint: '1 medium fruit or 1 cup',
    weight: 12,
  ),
  FoodGroup(
    id: 'vegetables',
    name: 'Vegetables',
    category: FoodCategory.adequacy,
    emoji: '🥦',
    servingHint: '1 cup raw or ½ cup cooked',
    weight: 15,
  ),
  FoodGroup(
    id: 'whole_grains',
    name: 'Whole Grains',
    category: FoodCategory.adequacy,
    emoji: '🌾',
    servingHint: '½ cup cooked or 1 slice',
    weight: 13,
  ),
  FoodGroup(
    id: 'proteins',
    name: 'Proteins',
    category: FoodCategory.adequacy,
    emoji: '🍗',
    servingHint: '100g or 3-4 oz',
    weight: 11,
  ),
  FoodGroup(
    id: 'dairy',
    name: 'Dairy',
    category: FoodCategory.adequacy,
    emoji: '🥛',
    servingHint: '1 cup milk/yogurt',
    weight: 10,
  ),
  FoodGroup(
    id: 'seafood',
    name: 'Seafood',
    category: FoodCategory.adequacy,
    emoji: '🐟',
    servingHint: '100g',
    weight: 12,
  ),
  FoodGroup(
    id: 'nuts',
    name: 'Nuts & Seeds',
    category: FoodCategory.adequacy,
    emoji: '🥜',
    servingHint: '1 handful (28g)',
    weight: 11,
  ),

  // === Moderation (Limit) ===
  FoodGroup(
    id: 'refined_grains',
    name: 'Refined Grains',
    category: FoodCategory.moderation,
    emoji: '🍞',
    servingHint: '1 slice of bread / 1/2 cup rice',
    weight: 4,
  ),
  FoodGroup(
    id: 'fried_food',
    name: 'Fried Food',
    category: FoodCategory.moderation,
    emoji: '🍟',
    servingHint: '1 drumstick / 100g fries',
    weight: 12,
  ),
  FoodGroup(
    id: 'processed_food',
    name: 'Processed Food',
    category: FoodCategory.moderation,
    emoji: '🌭',
    servingHint: '1 sausage/spam',
    weight: 12,
  ),
  FoodGroup(
    id: 'sweets',
    name: 'Sweets & Sugary Drinks',
    category: FoodCategory.moderation,
    emoji: '🍭',
    servingHint: '1 can of coke (12oz) / 4 lollipops',
    weight: 14,
  ),
];