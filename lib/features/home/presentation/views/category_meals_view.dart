import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/home/presentation/view_model/category_meals_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/category_meals_state.dart';
import 'package:food_app/features/home/presentation/views/widgets/home_status.dart';
import 'package:food_app/features/home/presentation/views/widgets/meal_card.dart';

class CategoryMealsView extends StatelessWidget {
  const CategoryMealsView({
    super.key,
    required this.categoryName,
    this.categoryDescription,
  });

  final String categoryName;
  final String? categoryDescription;

  @override
  Widget build(BuildContext context) {
    return _CategoryMealsContent(
      categoryName: categoryName,
      categoryDescription: categoryDescription,
    );
  }
}

class _CategoryMealsContent extends StatefulWidget {
  const _CategoryMealsContent({
    required this.categoryName,
    this.categoryDescription,
  });

  final String categoryName;
  final String? categoryDescription;

  @override
  State<_CategoryMealsContent> createState() => _CategoryMealsContentState();
}

class _CategoryMealsContentState extends State<_CategoryMealsContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryMealsCubit>();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: cubit.searchMeals,
              style: const TextStyle(color: AppColor.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: '${AppStrings.searchMealsHint} in ${widget.categoryName}',
                hintStyle: const TextStyle(color: AppColor.hint, fontSize: 13),
                filled: true,
                fillColor: AppColor.inputField,
                prefixIcon: const Icon(Icons.search, color: AppColor.primary, size: 20),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.clear, color: AppColor.hint, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        cubit.searchMeals('');
                      },
                    );
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColor.primary,
              onRefresh: () => cubit.getMealsByCategory(widget.categoryName),
              child: BlocBuilder<CategoryMealsCubit, CategoryMealsState>(
                builder: (context, state) {
                  if (state is CategoryMealsLoading || state is CategoryMealsInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    );
                  }

                  if (state is CategoryMealsFailure) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: HomeStatus(
                        icon: Icons.cloud_off_rounded,
                        message: state.errorMessage,
                        onRetry: cubit.retry,
                      ),
                    );
                  }

                  if (state is CategoryMealsSuccess) {
                    if (state.meals.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: const HomeStatus(
                          icon: Icons.search_off_rounded,
                          message: AppStrings.noMealsFound,
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: state.meals.length,
                      itemBuilder: (context, index) {
                        final meal = state.meals[index];
                        return MealCard(
                          meal: meal,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.mealDetails,
                              arguments: meal.id,
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
