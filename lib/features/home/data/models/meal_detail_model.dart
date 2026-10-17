class MealIngredient {
  const MealIngredient({
    required this.name,
    required this.measure,
  });

  final String name;
  final String measure;
}

class MealDetailModel {
  const MealDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
    required this.tags,
    required this.youtube,
    required this.ingredients,
  });

  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;
  final String? tags;
  final String? youtube;
  final List<MealIngredient> ingredients;

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    final ingredientsList = <MealIngredient>[];

    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient is String &&
          ingredient.trim().isNotEmpty) {
        final ingredientName = ingredient.trim();
        final measureStr = (measure is String ? measure.trim() : '');
        ingredientsList.add(
          MealIngredient(
            name: ingredientName,
            measure: measureStr,
          ),
        );
      }
    }

    return MealDetailModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      thumb: json['strMealThumb'] as String? ?? '',
      tags: json['strTags'] as String?,
      youtube: json['strYoutube'] as String?,
      ingredients: ingredientsList,
    );
  }
}
