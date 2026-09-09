import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book_app/core/app_colors.dart';
import 'package:recipe_book_app/core/app_strings.dart';
import 'package:recipe_book_app/presentation/features/provider/recipe_provider.dart';
import 'package:recipe_book_app/presentation/features/screens/Details/recipe_details_screen.dart';

import '../../../core/widget/recipe_card.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'All',
    'Italian',
    'Chinese',
    'Indian',
    'French',
    'Japanese',
  ];

  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().fetchRecipesByCategory(_selectedCategory);
    });
  }

  void _openRecipeDetails(int recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailsScreen(recipeId: recipeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            Text(
              'Omar Usman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(AppStrings.profileImageUrl),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/Search.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                _buildCategoryChips(),

                SizedBox(
                  height: 210,
                  child: Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categoryRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = provider.categoryRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: RecipeCard(
                              recipe: recipe,
                              onTap: () => _openRecipeDetails(recipe.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Text(
                  'Recipe of The Weeks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Consumer<RecipeProvider>(
                  builder: (context, recipeProvider, child) {
                    return SizedBox(
                      height: 290,
                      child: ListView.builder(
                        itemCount: recipeProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          final recipe = recipeProvider.searchResults[index];
                          return GestureDetector(
                            onTap: () => _openRecipeDetails(recipe.id),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            recipe.image,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                recipe.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                spacing: 3,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/star.png',
                                                    width: 18,
                                                    height: 18,
                                                    color: Colors.amber,
                                                  ),
                                                  Text(
                                                    '5.4',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'By: Kadin Curtis',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/bookmark.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey.withValues(
                                        alpha: 0.5,
                                      ),
                                      thickness: 1,
                                      height: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                context.read<RecipeProvider>().fetchRecipesByCategory(
                  _selectedCategory,
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.textSecondary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}