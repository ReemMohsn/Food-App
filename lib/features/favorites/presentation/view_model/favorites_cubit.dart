import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/services/shared_preferences_service.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._sharedPreferencesService) : super(const FavoritesInitial());

  final SharedPreferencesService _sharedPreferencesService;

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      final list = await _sharedPreferencesService.getFavorites();
      emit(FavoritesSuccess(favorites: List.unmodifiable(list)));
    } catch (e) {
      emit(FavoritesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> toggleFavorite(MealSummaryModel meal) async {
    final currentFavorites = state is FavoritesSuccess
        ? List<MealSummaryModel>.from((state as FavoritesSuccess).favorites)
        : await _sharedPreferencesService.getFavorites();

    final index = currentFavorites.indexWhere((m) => m.id == meal.id);
    if (index >= 0) {
      currentFavorites.removeAt(index);
      await _sharedPreferencesService.removeFavorite(meal.id);
    } else {
      currentFavorites.add(meal);
      await _sharedPreferencesService.addFavorite(meal);
    }

    emit(FavoritesSuccess(favorites: List.unmodifiable(currentFavorites)));
  }

  Future<void> removeFavorite(String mealId) async {
    final currentFavorites = state is FavoritesSuccess
        ? List<MealSummaryModel>.from((state as FavoritesSuccess).favorites)
        : await _sharedPreferencesService.getFavorites();

    currentFavorites.removeWhere((m) => m.id == mealId);
    await _sharedPreferencesService.removeFavorite(mealId);

    emit(FavoritesSuccess(favorites: List.unmodifiable(currentFavorites)));
  }

  bool isFavorite(String mealId) {
    if (state is FavoritesSuccess) {
      return (state as FavoritesSuccess).isFavorite(mealId);
    }
    return false;
  }
}
