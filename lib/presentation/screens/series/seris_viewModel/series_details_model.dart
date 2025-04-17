class Series {
  final String title;
  final String imageUrl;
  final String description;
  final List<CastMember> cast;
  final List<Episode> episodes;
  final List<String> genre;
  final String seriesId;
  final List<String> categories;
  final String rating;
  final List<String> seasons;  // Add seasons field


  Series({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.cast,
    required this.episodes,
    required this.seriesId,
    required this.categories,
    required this.genre,
    required this.rating,
    required this.seasons,  // Add seasons to constructor
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    List<CastMember> castList = [];
    if (json['cast'] != null) {
      if (json['cast'] is List) {
        castList = (json['cast'] as List)
            .map((e) => CastMember.fromJson({'name': e.toString(), 'role': ''}))
            .toList();
      } else {
        castList = [
          CastMember.fromJson({'name': json['cast'].toString(), 'role': ''})
        ];
      }
    }

    List<Episode> episodesList = [];
    if (json['episodes'] != null && json['episodes'] is List) {
      episodesList = (json['episodes'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<String> genreList = [];
    if (json['genre'] != null && json['genre'] is String) {
      genreList = (json['genre'] as String).split(", ").toList();
    }

    List<String> categoriesList = [];
    if (json['categories'] != null && json['categories'] is List) {
      categoriesList = List<String>.from(
        (json['categories'] as List).map((x) => x.toString()),
      );
    }

    List<String> seasonsList = [];
    if (json['seasons'] != null && json['seasons'] is List) {
      seasonsList = List<String>.from(
        (json['seasons'] as List).map((x) => x.toString()),
      );
    }

    return Series(
      title: json['name'] ?? '',
      imageUrl: json['cover'] ?? '',
      description: json['plot'] ?? '',
      cast: castList,
      episodes: episodesList,
      seriesId: (json['series_id'] ?? '').toString(),
      categories: categoriesList,
      genre: genreList,
      rating: json['rating']?.toString() ?? '',
      seasons: seasonsList,

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'image': imageUrl,
      'description': description,
      'cast': cast.map((e) => e.toJson()).toList(),
      'episodes': episodes.map((e) => e.toJson()).toList(),
      'series_id': seriesId,
      'categories': categories,
      'genre': genre.join(", "),
      'rating': rating,
      'seasons': seasons,  // Add seasons to JSON
    };
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'series_id': seriesId,
      'cover': imageUrl,
      'description': description,
    };
  }

  factory Series.mapToSeries(Map<String, String> map) {
    return Series(
      title: map['title'] ?? '',
      imageUrl: map['cover'] ?? '',
      description: map['description'] ?? '',
      cast: [],
      episodes: [],
      seriesId: map['stream_id'] ?? '',
      categories: [],
      genre: [],
      rating: '',
      seasons: [],

    );
  }

}


class CastMember {
  final String name;
  final String role;
  final String profileImage; // Add this

  CastMember({required this.name, required this.role, this.profileImage = ''});

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'profileImage': profileImage,
    };
  }
}

class Episode {
  final String id;
  final int episodeNum;
  final String title;
  final String containerExtension;
  final String duration;
  final int bitrate;
  final String customSid;
  final int added;
  final int season;
  final String directSource;

  Episode({
    required this.id,
    required this.episodeNum,
    required this.title,
    required this.containerExtension,
    required this.duration,
    required this.bitrate,
    required this.customSid,
    required this.added,
    required this.season,
    required this.directSource,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        id: json['id']?.toString() ?? '',
        episodeNum: json['episode_num'] is int
            ? json['episode_num']
            : int.tryParse(json['episode_num']?.toString() ?? '0') ?? 0,
        title: json['title']?.toString() ?? '',
        containerExtension: json['container_extension']?.toString() ?? '',
    duration: json['info']?['duration']?.toString() ?? '',
    bitrate: json['bitrate'] is int
    ? json['bitrate']
        : int.tryParse(json['bitrate']?.toString() ?? '0') ?? 0,
    customSid: json['custom_sid']?.toString() ?? '',
    added: json['added'] is int
    ? json['added']
        : int.tryParse(json['added']?.toString() ?? '0') ?? 0,
    season: json['season'] is int
    ? json['season']
        : int.tryParse(json['season']?.toString() ?? '1') ?? 1,
    directSource: json['direct_source']?.toString() ?? '',
    );
    }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_num': episodeNum,
      'title': title,
      'container_extension': containerExtension,
      'info': {
        'duration': duration,
      },
      'bitrate': bitrate,
      'custom_sid': customSid,
      'added': added,
      'season': season,
      'direct_source': directSource,
    };
  }
}


