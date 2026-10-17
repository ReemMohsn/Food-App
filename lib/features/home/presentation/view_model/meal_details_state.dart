import 'package:food_app/features/home/data/models/meal_detail_model.dart';

sealed class MealDetailsState {
  const MealDetailsState();
}

class MealDetailsInitial extends MealDetailsState {
  const MealDetailsInitial();
}

class MealDetailsLoading extends MealDetailsState {
  const MealDetailsLoading();
}

class MealDetailsSuccess extends MealDetailsState {
  const MealDetailsSuccess({required this.meal});

  final MealDetailModel meal;
}

class MealDetailsFailure extends MealDetailsState {
  const MealDetailsFailure({required this.errorMessage});

  final String errorMessage;
}
