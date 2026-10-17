import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/repositories/home_repository.dart';
import 'package:food_app/features/home/presentation/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeInitial());

  final HomeRepository _repository;
  List<CategoryModel> _allCategories = const [];
  String _query = '';

  Future<void> getCategories() async {
    emit(const HomeLoading());
    final result = await _repository.getCategories();
    if (isClosed) return;

    result.fold(
      (failure) => emit(HomeFailure(errorMessage: failure.message)),
      (categories) {
        _allCategories = categories;
        _emitCategories();
      },
    );
  }

  void searchCategories(String query) {
    _query = query.trim();
    if (_allCategories.isNotEmpty) {
      _emitCategories();
    }
  }

  void _emitCategories() {
    if (_query.isEmpty) {
      emit(HomeSuccess(categories: _allCategories, query: ''));
      return;
    }

    final lower = _query.toLowerCase();
    final filtered = _allCategories
        .where(
          (c) =>
              c.name.toLowerCase().contains(lower) ||
              c.description.toLowerCase().contains(lower),
        )
        .toList(growable: false);

    emit(HomeSuccess(categories: filtered, query: _query));
  }
}
