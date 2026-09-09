import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book_app/core/app_colors.dart';
import 'package:recipe_book_app/core/app_strings.dart';
import 'package:recipe_book_app/presentation/features/provider/recipe_provider.dart';
import 'package:recipe_book_app/presentation/features/screens/Details/widgets/recipe_detail.dart';
import 'package:recipe_book_app/presentation/features/screens/Details/widgets/recipe_ingredient.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool _isBookmarked = false;
  bool _isSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().fetchRecipeDetails(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          if (provider.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.detailError != null || provider.recipeDetail == null) {
            return Center(
              child: Text(
                provider.detailError ?? AppStrings.failedToLoadRecipe,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final recipe = provider.recipeDetail!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(recipe.image),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleAndRating(recipe.title),
                          const SizedBox(height: 12),
                          _buildQuickInfoRow(recipe),
                          const SizedBox(height: 16),
                          _buildAuthorRow(recipe.sourceName),
                          const SizedBox(height: 20),
                          const Text(
                            AppStrings.ingredients,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildIngredientsList(recipe.ingredients),
                          const SizedBox(height: 20),
                          const Text(
                            AppStrings.description,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildSummary(recipe.summary),
                          const SizedBox(height: 24),
                          _buildWatchVideosButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage(String imageUrl) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    AppStrings.recipeDetails,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isBookmarked = !_isBookmarked);
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.white70.withOpacity(0.4),
                      child: _isBookmarked
                          ? SvgPicture.asset(
                        'assets/images/bookmark.svg',
                        width: 20,
                        height: 20,
                        color: Colors.red,
                      )
                          : Image.asset(
                        'assets/images/bookmark.png',
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.white70.withOpacity(0.4),
        child: Icon(icon, color: Colors.black, size: 18,fontWeight: FontWeight.bold,),
      ),
    );
  }

  Widget _buildTitleAndRating(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.starColor, size: 18),
            const SizedBox(width: 4),
            Text(
              AppStrings.defaultRating,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoRow(RecipeDetail recipe) {
    return Row(
      children: [
        _infoChip(Icons.access_time, '${recipe.readyInMinutes}${AppStrings.mins}'),
        const SizedBox(width: 20),
        _infoChip(Icons.bar_chart, AppStrings.difficultyMedium),
        const SizedBox(width: 20),
        _infoChip(
          Icons.local_fire_department,
          recipe.calories > 0 ? '${recipe.calories}${AppStrings.cal}' : '--',
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAuthorRow(String author) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.grey200,
          child: Icon(Icons.person, size: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        Text(
          author,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(List<RecipeIngredient> ingredients) {
    if (ingredients.isEmpty) {
      return const Text(
        AppStrings.noInstructions,
        style: TextStyle(color: AppColors.textSecondary,),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return SizedBox(
            width: 68,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.grey300,
                  backgroundImage: ingredient.image.isNotEmpty
                      ? NetworkImage(ingredient.image)
                      : null,
                  child: ingredient.image.isEmpty
                      ? const Icon(Icons.set_meal, color: AppColors.grey)
                      : null,
                ),
                const SizedBox(height: 6),
                Text(
                  ingredient.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.black,fontWeight: .bold),
                ),
                Text(
                  '${ingredient.amount % 1 == 0 ? ingredient.amount.toInt() : ingredient.amount} ${ingredient.unit}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(String summary) {
    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    const style = TextStyle(
      fontSize: 13,
      height: 1.4,
      color: AppColors.textSecondary,
    );
    const readMoreStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );

    if (_isSummaryExpanded) {
      return Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(text: summary),
            TextSpan(
              text: '  ${AppStrings.readLess}',
              style: readMoreStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => _isSummaryExpanded = false),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        const maxLines = 3;
        const suffix = '....Read More';

        final fullPainter = TextPainter(
          text: TextSpan(text: summary, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        if (!fullPainter.didExceedMaxLines) {
          return Text(summary, style: style);
        }

        int low = 0;
        int high = summary.length;
        String bestFit = '';

        while (low <= high) {
          final mid = (low + high) ~/ 2;
          final candidate = summary.substring(0, mid).trimRight() + suffix;

          final painter = TextPainter(
            text: TextSpan(text: candidate, style: style),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: maxWidth);

          if (painter.didExceedMaxLines) {
            high = mid - 1;
          } else {
            bestFit = summary.substring(0, mid).trimRight();
            low = mid + 1;
          }
        }
        if (bestFit.length > 10) {
          bestFit = bestFit.substring(0, bestFit.length - 10).trimRight();
        }

        return Text.rich(
          TextSpan(
            style: style,
            children: [
              TextSpan(text: '$bestFit....'),
              TextSpan(
                text: AppStrings.readMore,
                style: readMoreStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => _isSummaryExpanded = true),
              ),
            ],
          ),
          maxLines: maxLines,
          overflow: TextOverflow.clip,
        );
      },
    );
  }

  Widget _buildWatchVideosButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        icon: const Icon(Icons.play_circle_fill, color: Colors.white,size: 25,),
        label: const Text(
          AppStrings.watchVideos,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}