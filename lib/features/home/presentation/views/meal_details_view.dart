import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/dependency_injection/injection_container.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:food_app/features/home/data/models/meal_detail_model.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';
import 'package:food_app/features/home/data/repositories/home_repository.dart';
import 'package:food_app/features/home/presentation/view_model/meal_details_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/meal_details_state.dart';
import 'package:food_app/features/home/presentation/views/widgets/home_status.dart';

class MealDetailsView extends StatelessWidget {
  const MealDetailsView({
    super.key,
    required this.mealId,
  });

  final String mealId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealDetailsCubit(sl<HomeRepository>())..getMealDetails(mealId),
      child: const _MealDetailsContent(),
    );
  }
}

class _MealDetailsContent extends StatelessWidget {
  const _MealDetailsContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealDetailsCubit>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocBuilder<MealDetailsCubit, MealDetailsState>(
        builder: (context, state) {
          if (state is MealDetailsLoading || state is MealDetailsInitial) {
            return const Scaffold(
              backgroundColor: AppColor.background,
              body: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            );
          }

          if (state is MealDetailsFailure) {
            return Scaffold(
              backgroundColor: AppColor.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: HomeStatus(
                icon: Icons.error_outline_rounded,
                message: state.errorMessage,
                onRetry: cubit.retry,
              ),
            );
          }

          if (state is MealDetailsSuccess) {
            final meal = state.meal;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppColor.primary,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppColor.textPrimary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favState) {
                          final isFav = favState is FavoritesSuccess &&
                              favState.isFavorite(meal.id);
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 20,
                                color: isFav
                                    ? AppColor.primary
                                    : AppColor.textPrimary,
                              ),
                              onPressed: () {
                                context.read<FavoritesCubit>().toggleFavorite(
                                      MealSummaryModel(
                                        id: meal.id,
                                        name: meal.name,
                                        thumb: meal.thumb,
                                      ),
                                    );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          meal.thumb,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColor.secondary,
                            child: const Icon(
                              Icons.restaurant,
                              size: 64,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black38,
                                Colors.transparent,
                                Colors.black54,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColor.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (meal.category.isNotEmpty)
                              _buildBadge(
                                icon: Icons.category_rounded,
                                label: meal.category,
                                color: AppColor.primary,
                              ),
                            if (meal.area.isNotEmpty)
                              _buildBadge(
                                icon: Icons.public_rounded,
                                label: meal.area,
                                color: const Color(0xFF2E7D32),
                              ),
                            if (meal.tags != null && meal.tags!.isNotEmpty)
                              ...meal.tags!
                                  .split(',')
                                  .take(3)
                                  .map(
                                    (tag) => _buildBadge(
                                      icon: Icons.tag_rounded,
                                      label: tag.trim(),
                                      color: const Color(0xFF6A1B9A),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          title: AppStrings.ingredients,
                          count: meal.ingredients.length,
                          icon: Icons.kitchen_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildIngredientsList(meal.ingredients),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          title: AppStrings.instructions,
                          icon: Icons.menu_book_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildInstructionsCard(meal.instructions),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    int? count,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColor.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count items',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientsList(List<MealIngredient> ingredients) {
    if (ingredients.isEmpty) {
      return const Text(
        'No ingredients listed.',
        style: TextStyle(color: AppColor.textSecondary),
      );
    }

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: ingredients.length,
        separatorBuilder: (context, index) => const Divider(
          height: 12,
          thickness: 0.5,
          color: AppColor.divider,
        ),
        itemBuilder: (context, index) {
          final item = ingredients[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
                if (item.measure.isNotEmpty)
                  Text(
                    item.measure,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textSecondary,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructionsCard(String instructions) {
    final cleanInstructions = instructions.trim();
    if (cleanInstructions.isEmpty) {
      return const Text(
        'No instructions available.',
        style: TextStyle(color: AppColor.textSecondary),
      );
    }

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          cleanInstructions,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColor.textPrimary,
          ),
        ),
      ),
    );
  }
}
