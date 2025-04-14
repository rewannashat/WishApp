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
  LiveStream mapToLiveStream() {
    return LiveStream(
      name: this.name,
      streamId: this.streamId,
      thumbnail: this.thumbnail,
      streamUrl: this.streamUrl,
      categoryId: this.categoryId,
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
