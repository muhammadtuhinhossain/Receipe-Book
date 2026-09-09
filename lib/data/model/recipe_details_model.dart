import '../../presentation/features/screens/Details/widgets/recipe_detail.dart';
import '../../presentation/features/screens/Details/widgets/recipe_ingredient.dart';

class RecipeDetailModel extends RecipeDetail {
  RecipeDetailModel({
    required super.id,
    required super.title,
    required super.image,
    required super.readyInMinutes,
    required super.servings,
    required super.sourceName,
    required super.summary,
    required super.calories,
    required super.ingredients,
    required super.instructionSteps,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    // Ingredients
    final List rawIngredients = json['extendedIngredients'] ?? [];
    final ingredients = rawIngredients.map((e) {
      return RecipeIngredient(
        name: (e['nameClean'] ?? e['name'] ?? '').toString(),
        image: e['image'] != null
            ? 'https://img.spoonacular.com/ingredients_100x100/${e['image']}'
            : '',
        amount: (e['amount'] ?? 0).toDouble(),
        unit: (e['unit'] ?? '').toString(),
      );
    }).toList();

    // Instructions: prefer step-by-step analyzedInstructions, fallback to
    // splitting the plain "instructions" text.
    List<String> steps = [];
    final List analyzed = json['analyzedInstructions'] ?? [];
    if (analyzed.isNotEmpty && analyzed[0]['steps'] != null) {
      final List rawSteps = analyzed[0]['steps'];
      steps = rawSteps.map((s) => s['step'].toString()).toList();
    } else if (json['instructions'] != null &&
        json['instructions'].toString().isNotEmpty) {
      steps = json['instructions']
          .toString()
          .split('.')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .map((s) => '$s.')
          .toList();
    }

    // Strip HTML tags from the summary (e.g. <b>, <a href="...">).
    final rawSummary = (json['summary'] ?? '').toString();
    final cleanSummary = rawSummary.replaceAll(RegExp(r'<[^>]*>'), '');

    // Calories only come back when the request includes
    // `includeNutrition=true`; default to 0 when absent.
    int calories = 0;
    final nutrition = json['nutrition'];
    if (nutrition != null && nutrition['nutrients'] != null) {
      final List nutrients = nutrition['nutrients'];
      final match = nutrients.firstWhere(
            (n) => n['name'] == 'Calories',
        orElse: () => null,
      );
      if (match != null) {
        calories = (match['amount'] as num).round();
      }
    }

    return RecipeDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      sourceName: json['sourceName'] ?? json['creditsText'] ?? 'Unknown',
      summary: cleanSummary,
      calories: calories,
      ingredients: ingredients,
      instructionSteps: steps,
    );
  }
}