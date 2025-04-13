class SeriesCategory {
  final String categoryId;
  final String categoryName;
  final String seriesId;

  SeriesCategory({required this.categoryId, required this.categoryName , required this.seriesId});

  // A factory constructor to create a SeriesCategory from JSON data
  factory SeriesCategory.fromJson(Map<String, dynamic> json) {
    return SeriesCategory(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      seriesId: json['series_id'] ?? '',
    );
  }
}
