import 'package:dartz/dartz.dart';
import 'package:food_app/core/services/errors/failure.dart';
import 'package:food_app/core/services/request_handler.dart';
import 'package:food_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/meal_detail_model.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';

class HomeRepository {
  const HomeRepository(this._remote);

  final HomeRemoteDataSource _remote;

  Future<Either<Failure, List<CategoryModel>>> getCategories() =>
      requestHandler(_remote.getCategories);

  Future<Either<Failure, List<MealSummaryModel>>> getMealsByCategory(
    String category,
  ) =>
      requestHandler(() => _remote.getMealsByCategory(category));

  Future<Either<Failure, MealDetailModel>> getMealDetails(String id) =>
      requestHandler(() => _remote.getMealDetails(id));
}
