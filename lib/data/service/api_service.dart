import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_book_app/core/app_strings.dart';
import 'package:recipe_book_app/data/model/recipe_model.dart';
import 'package:recipe_book_app/domain/entities/recipe.dart';
import '../../presentation/features/screens/Details/widgets/recipe_detail.dart';
import '../model/recipe_details_model.dart';

class ApiService {
  Future<List<Recipe>> getRecipesCategory(String category) async {
    final url = category == 'All'
        ? '${AppStrings.baseUrl}/complexSearch?apiKey=${AppStrings.apiKey}'
        : '${AppStrings.baseUrl}/complexSearch?apiKey=${AppStrings.apiKey}&cuisine=$category';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List results = json['results'];
      return results.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse(
        '${AppStrings.baseUrl}/complexSearch?apiKey=${AppStrings.apiKey}&query=$query',
      ),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List results = json['results'];
      return results.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  /// Fetches full recipe details (ingredients, instructions, summary, etc.)
  /// for a single recipe by its Spoonacular id.
  Future<RecipeDetail> getRecipeDetails(int id) async {
    final url =
        '${AppStrings.baseUrl}/$id/information?apiKey=${AppStrings.apiKey}&includeNutrition=true';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RecipeDetailModel.fromJson(json);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}