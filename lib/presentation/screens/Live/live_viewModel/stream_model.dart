class LiveCategory {
  final String categoryId;
  final String categoryName;

  LiveCategory({
    required this.categoryId,
    required this.categoryName,
  });

  factory LiveCategory.fromJson(Map<String, dynamic> json) {
    return LiveCategory(
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
