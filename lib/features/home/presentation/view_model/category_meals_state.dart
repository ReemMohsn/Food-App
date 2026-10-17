import 'package:food_app/features/home/data/models/meal_summary_model.dart';

sealed class CategoryMealsState {
  const CategoryMealsState();
}

class CategoryMealsInitial extends CategoryMealsState {
  const CategoryMealsInitial();
}

class CategoryMealsLoading extends CategoryMealsState {
  const CategoryMealsLoading();
}

class CategoryMealsSuccess extends CategoryMealsState {
  const CategoryMealsSuccess({
    required this.meals,
    this.query = '',
  });

  final List<MealSummaryModel> meals;
  final String query;
}

class CategoryMealsFailure extends CategoryMealsState {
  const CategoryMealsFailure({required this.errorMessage});

  final String errorMessage;
}
