import '../../../data/models/food_groups.dart';
import 'search_cache.dart';

class CommonFoods {
  static final Map<String, String> _learnedMappings = {};

  static void init() {
    _addDefaultMappings();
  }

  static void _addDefaultMappings() {
    _learnedMappings.addAll({
      'apple': 'fruits',
      'banana': 'fruits',
      'orange': 'fruits',
      'strawberry': 'fruits',
      'blueberry': 'fruits',
      'mango': 'fruits',
      'grape': 'fruits',
      'pineapple': 'fruits',
      'kiwi': 'fruits',
      'watermelon': 'fruits',
      'broccoli': 'vegetables',
      'carrot': 'vegetables',
      'spinach': 'vegetables',
      'lettuce': 'vegetables',
      'tomato': 'vegetables',
      'cucumber': 'vegetables',
      'pepper': 'vegetables',
      'onion': 'vegetables',
      'potato': 'vegetables',
      'sweet potato': 'vegetables',
      'chicken': 'proteins',
      'grilled chicken': 'proteins',
      'beef': 'proteins',
      'steak': 'proteins',
      'eggs': 'proteins',
      'tofu': 'proteins',
      'fish': 'seafood',
      'salmon': 'seafood',
      'tuna': 'seafood',
      'shrimp': 'seafood',
      'rice': 'refined_grains',
      'brown rice': 'whole_grains',
      'oatmeal': 'whole_grains',
      'white bread': 'refined_grains',
      'whole grain bread': 'whole_grains',
      'quinoa': 'whole_grains',
      'milk': 'dairy',
      'yogurt': 'dairy',
      'cheese': 'dairy',
      'nuts': 'nuts',
      'almond': 'nuts',
      'peanut': 'nuts',
      'walnut': 'nuts',
      'fried chicken': 'fried_food',
      'french fries': 'fried_food',
      'pizza': 'fried_food',
      'burger': 'fried_food',
      'chips': 'processed_food',
      'sausage': 'processed_food',
      'soda': 'sweets',
      'candy': 'sweets',
      'chocolate': 'sweets',
      'ice cream': 'sweets',
      'cake': 'sweets',
      'pandesal': 'refined_grains',
      'ensaymada': 'refined_grains',
      'longganisa': 'processed_food',
      'tocino': 'processed_food',
      'hotdog': 'processed_food',
      'spam': 'processed_food',
      'chicken adobo': 'proteins',
      'pork adobo': 'proteins',
      'pancit': 'refined_grains',
      'sisig': 'proteins',
      'lechon': 'proteins',
      'halo-halo': 'sweets',
      'turon': 'sweets',
      'chicharon': 'fried_food',
      'skyflakes': 'refined_grains',
      'sago': 'sweets',
      'gulaman': 'sweets',
      'coke': 'sweets',
    });
  }

  static List<String> getCommonFoodNames() {
    if (_learnedMappings.isEmpty) {
      _addDefaultMappings();
    }
    return _learnedMappings.keys.toList()..sort();
  }

  static List<String> search(String query) {
    if (query.trim().isEmpty) {
      return getCommonFoodNames();
    }

    final q = query.toLowerCase().trim();
    return _learnedMappings.keys.where((name) => name.toLowerCase().contains(q)).toList();
  }

  static FoodGroup? getFoodGroup(String foodName) {
    final lower = foodName.toLowerCase().trim();

    final groupId = SearchCache.getUserCorrection(foodName) ?? _learnedMappings[lower];
    if (groupId != null) {
      return allFoodGroups.firstWhere(
        (g) => g.id == groupId,
        orElse: () => allFoodGroups.first,
      );
    }

    for (var group in allFoodGroups) {
      final gName = group.name.toLowerCase();
      if (lower.contains(gName) || gName.split(' ').any((w) => lower.contains(w))) {
        return group;
      }
    }

    return null;
  }

  static void learnMapping(String foodName, String groupId) {
    SearchCache.saveUserCorrection(foodName, groupId);
    _learnedMappings[foodName.toLowerCase().trim()] = groupId;
    print("🎓 Learned: $foodName → $groupId");
  }
}