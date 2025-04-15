import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../../domian/local/sharedPref.dart';
import 'cast_model.dart';
import 'movie_model.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  static MovieCubit get(context) => BlocProvider.of<MovieCubit>(context);

  /// base data ///
  final Dio _dio = Dio();
  final String baseUrl = "http://tgdns4k.com:8080/player_api.php";
  final String username = "6665e332412";
  final String password = "12977281747688";


 /// drowpdown data


  List<String> movieCategories = [];
  Map<String, String> movieCategoryIdToNameMap = {};
  String? selectedMovieCategory;

  Future<void> getMovieCategories() async {
    emit(CategoryLoadedState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_vod_categories',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        movieCategories.clear();
        movieCategoryIdToNameMap.clear();
        movieCategories.addAll(['Favorite', 'Recent View']);

        for (var item in data) {
          final categoryId = item['category_id'].toString();
          final categoryName = item['category_name'].toString();

          movieCategoryIdToNameMap[categoryId] = categoryName;
          movieCategories.add(categoryName);
        }

        // حدد أول كاتيجوري حقيقية (مش Favorite أو Recent)
        selectedMovieCategory = movieCategories.length > 2
            ? movieCategories[2]
            : 'Favorite';

        changeMovieCategory(selectedMovieCategory!); // Call your own logic

        emit(ToggleDropdownState());
      } else {
        emit(CategoryErrorState('Failed to load movie categories'));
      }
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }


  void changeMovieCategory(String name) {
    selectedMovieCategory = name;

    if (name == 'Favorite') {
      loadFavorites();
    } else if (name == 'Recent View') {
      loadFavorites();
    } else {
      // البحث عن id الخاص بالاسم
      final id = movieCategoryIdToNameMap.entries
          .firstWhere((entry) => entry.value == name,
          orElse: () => const MapEntry('', ''))
          .key;

      if (id.isNotEmpty) {
        loadMoviesByCategory(id); // Your method to get movies by ID
      }
    }
  }



  /// data in gridview
  List<MovieDetailModel> moviesList = [];
  List<String> categories = [];



  Future<void> loadMoviesByCategory(String categoryId) async {
    emit(MovieLoadingState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_vod_streams',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // طباعة كل البيانات الراجعة (للتحقق)
        print('🔹 Total movies received: ${data.length}');
        print('🔹 Sample movie: ${data.first}');

        // فلترة حسب category_id
        final filtered = data.where((movie) {
          return movie['category_id'] == categoryId;
        }).toList();

        // طباعة بعد الفلترة
        print('✅ Filtered movies for category $categoryId: ${filtered.length}');
        for (var movie in filtered) {
          print('🎬 Movie: ${movie['name']}');
        }

        moviesList = filtered.map((e) => MovieDetailModel.fromJson(e)).toList();

        emit(MoviesSuccessState());
      } else {
        print('❌ Error: ${response.statusMessage}');
        emit(MovieErrorState('Failed to load movies'));
      }
    } catch (e) {
      print('🔥 Exception: $e');
      emit(MovieErrorState(e.toString()));
    }
  }



  // == Favorite LOGIC ==//

  List<Map<String, String>> allMovies = [];
  List<Map<String, String>> filteredMovies = [];
  final Set<int> _favorites = {};

  // Load favorites from SharedPreferences
  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteMovies') ?? [];
    _favorites.addAll(favoriteIds.map((e) => int.parse(e)));
    emit(FavoriteLoadedState(Set<int>.from(_favorites)));
  }

  // Save favorites to SharedPreferences
  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favorites.map((e) => e.toString()).toList();
    prefs.setStringList('favoriteMovies', favoriteIds);
  }

  void toggleFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    if (movieId == null) return;

    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    saveFavorites();  // Save updated favorites to SharedPreferences
    emit(FavoriteUpdated(Set<int>.from(_favorites)));
  }

  bool isFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    return _favorites.contains(movieId);
  }

  List<Map<String, String>> get favoriteMovies =>
      _favorites.map((id) => allMovies.firstWhere((movie) => movie['id'] == id.toString(), orElse: () => {})).toList();


// == Category LOGIC ==//

  String? selectedCategoryId;
  String selectedCategoryName = 'Favorite';






  // Fetch Movies for Selected Category
  Future<void> fetchMoviesForCategory(String categoryId) async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_vod_streams',
      });

      if (response.statusCode == 200 && response.data is List) {
        final data = response.data as List;

        allMovies = data
            .where((movie) => movie['category_id'].toString() == categoryId)
            .map<Map<String, String>>((movie) => {
          'id': movie['stream_id'].toString(),
          'title': movie['name'] ?? '',
          'image': movie['stream_icon'] ?? '',
        })
            .toList();

        emit(MovieLoaded());
      }
    } catch (e) {
      print('Error fetching movies: $e');
      emit(MovieError());
    }
  }


  void changeCategory(String id, String name) {
    selectedCategoryId = id;
    selectedCategoryName = name;

    emit(ChangeCategoryState());

    if (id == 'fav') {
      // Display favorite movies when "Favorite" is selected
      filteredMovies = favoriteMovies;
    } else {
      // Fetch movies for the selected category
      fetchMoviesForCategory(id);
      filteredMovies = allMovies;
    }
  }

  void toggleDropdown() {
    emit(ToggleDropdownState());
  }

  // ====== Search LOGIC ======

  void searchMovies(String query) {
    if (query.isEmpty) {
      filteredMovies = List.from(allMovies);
    } else {
      filteredMovies = allMovies
          .where((movie) =>
          movie['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredMovies');
    emit(SearchMoviesState(filteredMovies));
  }

  bool isDropdownOpen = false;

  /// details of movie ///
  Future<MovieDetailModel?> fetchMovieDetails(String streamId) async {
    final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_vod_info&vod_id=$streamId';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final jsonData = response.data;

        // Log the full response to see the structure
        //  log('Movie Details Response: ${jsonEncode(jsonData)}');

        if (jsonData != null && jsonData['info'] != null && jsonData['movie_data'] != null) {
          final movieDetail = MovieDetailModel.fromJson(jsonData);
          return movieDetail;
        } else {
          log('No movie data found in the response.');
        }
      } else {
        log('Failed to fetch movie details: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching movie details: $e');
    }

    return null;
  }

  /// cast image and name for the details of movie ///

  Future<List<CastMemberModel>> fetchCastData(List<String> arrCast) async {
    final apiKey = '6c4fc80fb22f43f77d2ed3f68b5ef57f';
    List<CastMemberModel> castMembers = [];

    for (int i = 0; i < arrCast.length; i++) {
      final name = arrCast[i];
      final url = 'https://api.themoviedb.org/3/search/person?api_key=$apiKey&query=$name';

      try {
        final response = await Dio().get(url);

        if (response.statusCode == 200 && response.data['results'] != null) {
          final results = response.data['results'];
          if (results.isNotEmpty) {
            final actor = results[0]; // Get the top result
            final profilePath = actor['profile_path'];
            final profileImage = profilePath != null
                ? 'https://image.tmdb.org/t/p/w500$profilePath'
                : '';

            castMembers.add(CastMemberModel(name: name, profileImage: profileImage));
          } else {
            castMembers.add(CastMemberModel(name: name, profileImage: '')); // fallback
          }
        }
      } catch (e) {
        print('Error fetching $name: $e');
        castMembers.add(CastMemberModel(name: name, profileImage: ''));
      }
    }

    return castMembers;
  }

  List<CastMemberModel> castList = [];

  Future<void> loadCastData(List<String> castNames) async {
    emit(CastLoadingState());
    castList = await fetchCastData(castNames);
    emit(CastLoadedState());
  }


  /// moviePlayer link method ///
  ChewieController? chewieController;

  bool isMoviePlayerInitialized = false;

  Future<void> initializeMoviePlayer({
    required String streamId,
    required String extension,
  }) async {
    if (!isMoviePlayerInitialized) {
      isMoviePlayerInitialized = true;
      emit(MoviePlayerChangeValu());
    }

    emit(MoviePlayerLoade());

    try {
      final movieUrl =
          'http://tgdns4k.com:8080/movie/$username/$password/$streamId.$extension';

      final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(movieUrl));

      await videoPlayerController.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
      );

      emit(MoviePlayerLoaded(chewieController!));
    } catch (e) {
      emit(MoviePlayerError("Failed to load video: $e"));
    }
  }


  void disposePlayer() {
    chewieController?.dispose();
    chewieController = null;
  }





















  // ===== Placement LOGIC ===== //
  void reorderItems(int oldIndex, int newIndex) {
    if (filteredMovies.isEmpty || oldIndex == newIndex) return;

    if (oldIndex >= filteredMovies.length || newIndex >= filteredMovies.length) {
      return; // Prevent index errors
    }

    final item = filteredMovies.removeAt(oldIndex);
    filteredMovies.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);

    emit(MovieUpdatedState(List.from(filteredMovies))); // Update state correctly
  }



}