import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book_app/core/app_colors.dart';
import 'package:recipe_book_app/core/app_strings.dart';
import 'package:recipe_book_app/presentation/features/provider/recipe_provider.dart';

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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().fetchRecipesByCategory(_selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(fontSize: 16, fontWeight: .w400),
            ),
            Text('Omar Usman'),
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
            icon: Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Category',
                style: TextStyle(fontSize: 20, fontWeight: .w600),
              ),
              _buildCategoryChips(),
              
              Consumer<RecipeProvider>(
                builder: (context, provider,_) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: .horizontal,
                      itemCount: provider.categoryRecipes.length,
                        itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: RecipeCard(recipe: provider.categoryRecipes[index],),
                        );
                        }),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: (){
              setState(() {
                _selectedCategory = category;
                context.read<RecipeProvider>().fetchRecipesByCategory(_selectedCategory);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.background,
                  borderRadius: .circular(20),
                  border: Border.all(
                   color:  isSelected
                       ? AppColors.textSecondary
                       : AppColors.textSecondary
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Center(
                    child: Text(categories[index],
                    style: TextStyle(fontSize: 14,
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textSecondary
                    ),
                      overflow: .ellipsis,
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
