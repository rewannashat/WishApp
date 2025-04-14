class LiveStream {
  final String name;
  final int streamId;
  final String? thumbnail;
  final String? streamUrl;
  final String? categoryId;

  LiveStream({
    required this.name,
    required this.streamId,
    this.thumbnail,
    this.streamUrl,
    this.categoryId,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      name: json['name'] ?? 'Untitled',
      streamId: json['stream_id'] != null ? int.tryParse(json['stream_id'].toString()) ?? 0 : 0, // Ensure it's parsed as an int
      thumbnail: json['stream_icon'], // assuming `stream_icon` is the thumbnail
      streamUrl: json['stream_url'],
      categoryId: json['category_id'].toString(),
    );
  }

  // Map LiveStream to another LiveStream (if needed)
  factory LiveStream.mapToLiveStream(Map<String, String> map) {
    return LiveStream(
      name: map['title'] ?? '', // ✅ Use 'name' instead of 'title'
      streamId: int.tryParse(map['stream_id'] ?? '0') ?? 0,
      thumbnail: map['stream_icon'] ?? '',
      streamUrl: map['stream_url'] ?? '',
      categoryId: map['category_id'] ?? '',
    );
  }


  // Add the toMap method to convert LiveStream to a Map
  Map<String, String> toMap() {
    return {
      'name': name,
      'stream_id': streamId.toString(),
      'stream_icon': thumbnail.toString(),
      'stream_url': streamUrl.toString(),
      'category_id': categoryId.toString(),
    };
  }
}
