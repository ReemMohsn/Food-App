import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';
import 'package:food_app/features/home/data/repositories/home_repository.dart';
import 'package:food_app/features/home/presentation/view_model/category_meals_state.dart';

class CategoryMealsCubit extends Cubit<CategoryMealsState> {
  CategoryMealsCubit(this._repository) : super(const CategoryMealsInitial());

  final HomeRepository _repository;
  List<MealSummaryModel> _allMeals = const [];
  String _query = '';
  String _category = '';

  Future<void> getMealsByCategory(String category) async {
    _category = category;
    emit(const CategoryMealsLoading());
    final result = await _repository.getMealsByCategory(category);
    if (isClosed) return;

    result.fold(
      (failure) => emit(CategoryMealsFailure(errorMessage: failure.message)),
      (meals) {
        _allMeals = meals;
        _emitMeals();
      },
    );
  }

  void searchMeals(String query) {
    _query = query.trim();
    if (_allMeals.isNotEmpty) {
      _emitMeals();
    }
  }

  void retry() {
    if (_category.isNotEmpty) {
      getMealsByCategory(_category);
    }
  }

  void _emitMeals() {
    if (_query.isEmpty) {
      emit(CategoryMealsSuccess(meals: _allMeals, query: ''));
      return;
    }

    final lower = _query.toLowerCase();
    final filtered = _allMeals
        .where((m) => m.name.toLowerCase().contains(lower))
        .toList(growable: false);

    emit(CategoryMealsSuccess(meals: filtered, query: _query));
  }
}
