class StreamModel {
  final String streamId;
  final String categoryName;

  StreamModel({required this.streamId, required this.categoryName});

  // Factory method to create an instance from a Map
  factory StreamModel.fromMap(Map<String, dynamic> map) {
    return StreamModel(
      streamId: map['stream_id'],
      categoryName: map['category_name'],
    );
  }
}
