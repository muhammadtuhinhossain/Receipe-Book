import 'recipe_ingredient.dart';

class RecipeDetail {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String sourceName;
  final String summary;
  final int calories;
  final List<RecipeIngredient> ingredients;
  final List<String> instructionSteps;

  RecipeDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceName,
    required this.summary,
    required this.calories,
    required this.ingredients,
    required this.instructionSteps,
  });
}