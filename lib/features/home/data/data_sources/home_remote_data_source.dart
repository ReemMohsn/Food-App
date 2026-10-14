import 'package:food_app/core/constants/api_end_points.dart';
import 'package:food_app/core/services/api_service.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/meal_detail_model.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';

class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get(ApiEndPoints.categories);
    final data = response.data;
    if (data is Map<String, dynamic> && data['categories'] is List) {
      final list = data['categories'] as List;
      return list
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    }
    return const [];
  }

  Future<List<MealSummaryModel>> getMealsByCategory(String category) async {
    final response = await _apiService.get(
      ApiEndPoints.filter,
      queryParameters: {'c': category},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['meals'] is List) {
      final list = data['meals'] as List;
      return list
          .map((item) => MealSummaryModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    }
    return const [];
  }

  Future<MealDetailModel> getMealDetails(String id) async {
    final response = await _apiService.get(
      ApiEndPoints.lookup,
      queryParameters: {'i': id},
    );
    final data = response.data;
    if (data is Map<String, dynamic> &&
        data['meals'] is List &&
        (data['meals'] as List).isNotEmpty) {
      final first = (data['meals'] as List).first as Map<String, dynamic>;
      return MealDetailModel.fromJson(first);
    }
    throw Exception('Meal not found');
  }
}

