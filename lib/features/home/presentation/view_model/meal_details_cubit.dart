import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/home/data/repositories/home_repository.dart';
import 'package:food_app/features/home/presentation/view_model/meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  MealDetailsCubit(this._repository) : super(const MealDetailsInitial());

  final HomeRepository _repository;
  String _mealId = '';

  Future<void> getMealDetails(String id) async {
    _mealId = id;
    emit(const MealDetailsLoading());
    final result = await _repository.getMealDetails(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(MealDetailsFailure(errorMessage: failure.message)),
      (meal) => emit(MealDetailsSuccess(meal: meal)),
    );
  }

  void retry() {
    if (_mealId.isNotEmpty) {
      getMealDetails(_mealId);
    }
  }
}
