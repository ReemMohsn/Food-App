class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });

  final String id;
  final String name;
  final String thumb;
  final String description;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory'] as String? ?? '',
      name: json['strCategory'] as String? ?? '',
      thumb: json['strCategoryThumb'] as String? ?? '',
      description: json['strCategoryDescription'] as String? ?? '',
    );
  }
}
