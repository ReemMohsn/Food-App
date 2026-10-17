class MealSummaryModel {
  const MealSummaryModel({
    required this.id,
    required this.name,
    required this.thumb,
  });

  final String id;
  final String name;
  final String thumb;

  factory MealSummaryModel.fromJson(Map<String, dynamic> json) {
    return MealSummaryModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      thumb: json['strMealThumb'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumb,
    };
  }
}

