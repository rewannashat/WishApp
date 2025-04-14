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
            .map((e) => CastMember.fromJson({
          'name': e.toString(),
          'role': '',
        }))
            .toList();
      } else {
        castList = [
          CastMember.fromJson({
            'name': json['cast'].toString(),
            'role': '',
          })
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
      seasons: seasonsList,  // Add seasons list
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

  CastMember({required this.name, required this.role});

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
    };
  }
}

class Episode {
  final int id;
  final int episodeNum;
  final String title;
  final String containerExtension;
  final String duration;
  final int durationSecs;
  final VideoInfo? video;

  Episode({
    required this.id,
    required this.episodeNum,
    required this.title,
    required this.containerExtension,
    required this.duration,
    required this.durationSecs,
    required this.video,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final info = json['info'] ?? {};
    final video = info['video'] != null ? VideoInfo.fromJson(info['video']) : null;

    return Episode(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      episodeNum: json['episode_num'] is int
          ? json['episode_num']
          : int.tryParse(json['episode_num'].toString()) ?? 0,
      title: json['title'] ?? '',
      containerExtension: json['container_extension'] ?? '',
      duration: info['duration'] ?? '',
      durationSecs: info['duration_secs'] is int
          ? info['duration_secs']
          : int.tryParse(info['duration_secs'].toString()) ?? 0,
      video: video,
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
        'duration_secs': durationSecs,
        'video': video?.toJson(),
      },
    };
  }


}

class VideoInfo {
  final int index;
  final String codecName;
  final String codecLongName;
  final String profile;
  final String codecType;

  VideoInfo({
    required this.index,
    required this.codecName,
    required this.codecLongName,
    required this.profile,
    required this.codecType,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      index: json['index'] ?? 0,
      codecName: json['codec_name'] ?? '',
      codecLongName: json['codec_long_name'] ?? '',
      profile: json['profile'] ?? '',
      codecType: json['codec_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'codec_name': codecName,
      'codec_long_name': codecLongName,
      'profile': profile,
      'codec_type': codecType,
    };
  }
}




