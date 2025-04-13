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
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    // Handle cast - can be list or single string
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

    // Handle episodes safely
    List<Episode> episodesList = [];
    if (json['episodes'] != null && json['episodes'] is List) {
      episodesList = (json['episodes'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Handle genres
    List<String> genreList = [];
    if (json['genre'] != null && json['genre'] is String) {
      genreList = (json['genre'] as String).split(", ").toList();
    }

    // Handle categories safely as List<String>
    List<String> categoriesList = [];
    if (json['categories'] != null && json['categories'] is List) {
      categoriesList = List<String>.from(
        (json['categories'] as List).map((x) => x.toString()),
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
    };
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
  final String title;
  final String airDate;

  Episode({required this.title, required this.airDate});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'] ?? '',
      airDate: json['air_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'air_date': airDate,
    };
  }
}
