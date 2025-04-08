class Playlist {
  final String id;
  final String name;
  final String url;
  final bool isActive;
  final bool isProtected;

  Playlist({
    required this.id,
    required this.name,
    required this.url,
    required this.isActive,
    required this.isProtected,
  });

  // Convert from JSON to Playlist model
  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['_id'],
      name: json['name'],
      url: json['url'],
      isActive: json['isActive'],
      isProtected: json['isProtected'],
    );
  }
}
