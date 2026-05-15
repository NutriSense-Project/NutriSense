import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_search_result.dart';

class SpoonacularService {
  static const String baseUrl = "https://api.spoonacular.com";
  final String apiKey;

  SpoonacularService(this.apiKey);

  Future<List<FoodSearchResult>> searchFood(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food/search?query=$query&number=10&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List? ?? [];

      return results.map((item) {
        return FoodSearchResult(
          id: item['id'].toString(),
          name: item['name'] ?? item['title'] ?? '',
          imageUrl: item['image'],
          spoonacularCategory: item['category'],
        );
      }).toList();
    } else {
      throw Exception('Failed to search food');
    }
  }
}