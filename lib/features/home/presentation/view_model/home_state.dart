import 'package:food_app/features/home/data/models/category_model.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.categories,
    this.query = '',
  });

  final List<CategoryModel> categories;
  final String query;
}

class HomeFailure extends HomeState {
  const HomeFailure({required this.errorMessage});

  final String errorMessage;
}
