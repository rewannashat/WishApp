class FavoriteStream {
  final int streamId;
  final String name;
  final String url;

  FavoriteStream({
    required this.streamId,
    required this.name,
    required this.url,
  });

  factory FavoriteStream.fromMap(Map<String, dynamic> map) {
    return FavoriteStream(
      streamId: map['stream_id'],
      name: map['name'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stream_id': streamId,
      'name': name,
      'url': url,
    };
  }
}