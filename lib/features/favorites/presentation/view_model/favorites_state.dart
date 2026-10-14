import 'package:food_app/features/home/data/models/meal_summary_model.dart';

sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesSuccess extends FavoritesState {
  const FavoritesSuccess({required this.favorites});

  final List<MealSummaryModel> favorites;

  bool isFavorite(String mealId) => favorites.any((m) => m.id == mealId);
}

class FavoritesFailure extends FavoritesState {
  const FavoritesFailure({required this.errorMessage});

  final String errorMessage;
}
