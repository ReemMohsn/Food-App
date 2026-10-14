import 'dart:convert';
import 'package:food_app/core/constants/shared_preferences_keys.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<bool> get isOnboardingCompleted async =>
      await _preferences.getBool(SharedPreferencesKeys.onboardingCompleted) ??
      false;

  Future<void> setOnboardingCompleted() =>
      _preferences.setBool(SharedPreferencesKeys.onboardingCompleted, true);

  Future<String?> get accessToken async =>
      await _preferences.getString(SharedPreferencesKeys.accessToken);

  Future<void> setAccessToken(String token) =>
      _preferences.setString(SharedPreferencesKeys.accessToken, token);

  Future<List<MealSummaryModel>> getFavorites() async {
    final raw = await _preferences.getString(SharedPreferencesKeys.favoritesMeals);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((item) => MealSummaryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> saveFavorites(List<MealSummaryModel> meals) async {
    final raw = jsonEncode(meals.map((m) => m.toJson()).toList());
    await _preferences.setString(SharedPreferencesKeys.favoritesMeals, raw);
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == id);
  }

  Future<void> addFavorite(MealSummaryModel meal) async {
    final favorites = await getFavorites();
    if (!favorites.any((m) => m.id == meal.id)) {
      favorites.add(meal);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == id);
    await saveFavorites(favorites);
  }
}

