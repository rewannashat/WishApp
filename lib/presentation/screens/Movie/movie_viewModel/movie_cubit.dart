import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
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



  /*//== Favorite LOGIC ==//


  List<Map<String, String>> allMovies = [];
  List<Map<String, String>> filteredMovies = [];

  final Set<int> _favorites = {};


  void toggleFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    if (movieId == null) return;

    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    emit(FavoriteUpdated(Set<int>.from(_favorites)));
  }

  bool isFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    return _favorites.contains(movieId);
  }

  List<Map<String, String>> get favoriteMovies =>
      _favorites.map((id) => allMovies.firstWhere((movie) => movie['id'] == id.toString(), orElse: () => {})).toList();


  ///== Category LOGIC ==///

  List<Map<String, String>> categories = [];
  String? selectedCategoryId;
  String selectedCategoryName = 'Favorite';




// === Fetch Movie Categories ===
  Future<void> getMovieCategories() async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_vod_categories',
      });

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        categories = data
            .map<Map<String, String>>((cat) => {
          'id': cat['category_id'].toString(),
          'name': cat['category_name'].toString(),
        })
            .toList();
        // Add Favorite category manually
        categories.add({'id': 'fav', 'name': 'Favorite'});

        // Select the first category by default
        selectedCategoryId = categories.first['id'];
        selectedCategoryName = categories.first['name']!;

        // Fetch movies for first category (not favorite)
        if (selectedCategoryId != 'fav') {
          await fetchMoviesForCategory(selectedCategoryId!);
        }

        emit(CategoryLoadedState());
      }
    } catch (e) {
      print('Error fetching categories: $e');
      emit(CategoryErrorState());
    }
  }

// === Fetch Movies for Selected Category ===
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

        //log('✅ Movies loaded for categoryId=$categoryId → ${allMovies.length} items');
        emit(MovieLoaded());
      }
    } catch (e) {
      print('Error fetching movies: $e');
      emit(MovieError());
    }
  }

// === Handle Dropdown Change ===
  void changeCategory(String id, String name) {
    selectedCategoryId = id;
    selectedCategoryName = name;

    emit(ChangeCategoryState());

    if (id != 'fav') {
      fetchMoviesForCategory(id);
    }
  }

// === Dropdown Toggle State ===
  void toggleDropdown() {
    emit(ToggleDropdownState());
  }



*/

  // == Favorite LOGIC ==//

  List<Map<String, String>> allMovies = [];
  List<Map<String, String>> filteredMovies = [];

  final Set<int> _favorites = {};

  void toggleFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    if (movieId == null) return;

    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    emit(FavoriteUpdated(Set<int>.from(_favorites)));
  }

  bool isFavorite(int movieIndex) {
    final movieId = int.tryParse(allMovies[movieIndex]['id'] ?? '');
    return _favorites.contains(movieId);
  }

  List<Map<String, String>> get favoriteMovies =>
      _favorites.map((id) => allMovies.firstWhere((movie) => movie['id'] == id.toString(), orElse: () => {})).toList();


// == Category LOGIC ==//

  List<Map<String, String>> categories = [];
  String? selectedCategoryId;
  String selectedCategoryName = 'Favorite';

  Future<void> getMovieCategories() async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_vod_categories',
      });

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        categories = data
            .map<Map<String, String>>((cat) => {
          'id': cat['category_id'].toString(),
          'name': cat['category_name'].toString(),
        })
            .toList();
        // Add Favorite category manually
        categories.add({'id': 'fav', 'name': 'Favorite'});

        // Select the first category by default
        selectedCategoryId = categories.first['id'];
        selectedCategoryName = categories.first['name']!;

        // Fetch movies for the first category (not favorite)
        if (selectedCategoryId != 'fav') {
          await fetchMoviesForCategory(selectedCategoryId!);
        }

        emit(CategoryLoadedState());
      }
    } catch (e) {
      print('Error fetching categories: $e');
      emit(CategoryErrorState());
    }
  }

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

  Future<List<CastMember>> fetchCastData(List<String> arrCast) async {
    final apiKey = '6c4fc80fb22f43f77d2ed3f68b5ef57f';
    List<CastMember> castMembers = [];

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
                ? 'https://image.tmdb.org/t/p/w500/$profilePath'
                : '';

            castMembers.add(CastMember(name: name, profileImage: profileImage));
          } else {
            castMembers.add(CastMember(name: name, profileImage: '')); // fallback
          }
        }
      } catch (e) {
        print('Error fetching $name: $e');
        castMembers.add(CastMember(name: name, profileImage: ''));
      }
    }

    return castMembers;
  }

  List<CastMember> castList = [];

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
