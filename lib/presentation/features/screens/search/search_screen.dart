import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book_app/core/app_colors.dart';
import 'package:recipe_book_app/presentation/features/provider/recipe_provider.dart';
import 'package:recipe_book_app/presentation/features/screens/Details/recipe_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    context.read<RecipeProvider>().searchRecipes(
                      _searchController.text,
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<RecipeProvider>().clearSearchResults();
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return ListView.builder(
            itemCount: recipeProvider.searchResults.length,
            itemBuilder: (context, index) {
              final recipe = recipeProvider.searchResults[index];
              return GestureDetector(
                onTap: () => _openRecipeDetails(recipe.id),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/bookmark.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.red,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.withValues(alpha: 0.5),
                          thickness: 1,
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}