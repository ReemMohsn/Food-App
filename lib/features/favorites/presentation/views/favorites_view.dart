import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:food_app/features/favorites/presentation/views/widgets/favorite_meal_card.dart';
import 'package:food_app/features/home/presentation/views/meal_details_view.dart';
import 'package:food_app/features/main_home/presentation/view_model/main_home_cubit.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.textPrimary,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Switch to home tab
              context.read<MainHomeCubit>().changeIndex(0);
            }
          },
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is FavoritesFailure) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: AppColor.danger),
              ),
            );
          }

          final favorites = state is FavoritesSuccess ? state.favorites : [];

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 48,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore delicious recipes and tap the heart to save them here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 22,
              childAspectRatio: 0.72,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final meal = favorites[index];
              return FavoriteMealCard(
                meal: meal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealDetailsView(mealId: meal.id),
                    ),
                  );
                },
                onRemoveFavorite: () {
                  context.read<FavoritesCubit>().removeFavorite(meal.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
