import 'package:flutter/widgets.dart';
import 'package:recipe_book_app/data/service/api_service.dart';
import 'package:recipe_book_app/domain/entities/recipe.dart';

class RecipeProvider extends ChangeNotifier{
  final ApiService _apiService = ApiService();

  List<Recipe> _categoryRecipes = [];
  List<Recipe> get categoryRecipes => _categoryRecipes;

  List<Recipe> _searchResults = [];
  List<Recipe> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRecipesByCategory(String category) async{
    _isLoading = true;
    notifyListeners();
     try{
      _categoryRecipes = await _apiService.getRecipesCategory(category);
     }catch (e){
       print('Error fetching recipe by category: $e');
     }finally{
       _isLoading = false;
       notifyListeners();
     }
  }

  Future<void> searchRecipes(String query) async{
    _isLoading = true;
    notifyListeners();
    try{
      _searchResults = await _apiService.searchRecipes(query);
    }catch (e){
      print('Error searching recipes: $e');
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearSearchResults()async{
    _searchResults = [];
    notifyListeners();
  }
}