class MovieInfoCategory {
  final String categoryId;
  final String categoryName;

  MovieInfoCategory({
    required this.categoryId,
    required this.categoryName,
  });

  factory MovieInfoCategory.fromJson(Map<String, dynamic> json) {
    return MovieInfoCategory(
      categoryId: json['category_id'].toString(),
      categoryName: json['category_name'] ?? 'Unknown Category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }
}
