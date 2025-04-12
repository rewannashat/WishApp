class MovieDetailModel {
  final String movieImage;
  final List<String> backdropPath;
  final String tmdbId;
  final String youtubeTrailer;
  final String genre;
  final String plot;
  final String cast;
  final String rating;
  final String director;
  final String releaseDate;
  final String duration;
  final int durationSecs;
  final String streamId;
  final String name;
  final String year;

  // New fields from movie_data
  final String added;
  final String categoryId;
  final String containerExtension;
  final String? customSid;
  final String directSource;

  MovieDetailModel({
    required this.movieImage,
    required this.backdropPath,
    required this.tmdbId,
    required this.youtubeTrailer,
    required this.genre,
    required this.plot,
    required this.cast,
    required this.rating,
    required this.director,
    required this.releaseDate,
    required this.duration,
    required this.durationSecs,
    required this.streamId,
    required this.name,
    required this.year,
    required this.added,
    required this.categoryId,
    required this.containerExtension,
    required this.customSid,
    required this.directSource,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final info = json['info'] ?? {};
    final movieData = json['movie_data'] ?? {};

    return MovieDetailModel(
      movieImage: info['movie_image'] ?? '',
      backdropPath: List<String>.from(info['backdrop_path'] ?? []),
      tmdbId: info['tmdb_id']?.toString() ?? '',
      youtubeTrailer: info['youtube_trailer'] ?? '',
      genre: info['genre'] ?? '',
      plot: info['plot'] ?? '',
      cast: info['cast'] ?? '',
      rating: info['rating']?.toString() ?? '',
      director: info['director'] ?? '',
      releaseDate: info['releasedate'] ?? '',
      duration: info['duration'] ?? '',
      durationSecs: info['duration_secs'] is int
          ? info['duration_secs']
          : int.tryParse(info['duration_secs']?.toString() ?? '') ?? 0,
      streamId: movieData['stream_id']?.toString() ?? '',
      name: movieData['name'] ?? '',
      year: info['year']?.toString() ?? '',

      // New fields from movie_data
      added: movieData['added']?.toString() ?? '',
      categoryId: movieData['category_id']?.toString() ?? '',
      containerExtension: movieData['container_extension'] ?? '',
      customSid: movieData['custom_sid']?.toString(),
      directSource: movieData['direct_source'] ?? '',
    );
  }
}
