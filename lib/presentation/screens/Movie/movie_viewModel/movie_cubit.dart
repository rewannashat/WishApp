import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'cast_model.dart';
import 'movie_model.dart';
import 'movie_states.dart';
import 'movieinfo_model.dart';

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






// == Category LOGIC ==//

  List<String> categories = [];
  String? selectedCategoryId;
  String? selectedCategory ;
  String selectedCategoryName = 'Favorite';
  Map<String, String> categoryIdToNameMap = {};


  Future<void> getMovieCategories() async {
    final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_vod_categories';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        categories.clear();
        categoryIdToNameMap.clear();
        categories.addAll(['Favorite', 'Recent View']); // Fallbacks

        for (var item in data) {
          final category = MovieInfoCategory.fromJson(item);
          categoryIdToNameMap[category.categoryId] = category.categoryName;
          categories.add(category.categoryName);
        }

        // Auto-select first actual category (skipping favorites)
        selectedCategory = categories.length > 2 ? categories[2] : '';
        changeCategory(selectedCategory!);

        emit(ChangeCategoryState());
      } else {
        log('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching movie categories: $e');
    }
  }

  void changeCategory(String newCategory) async {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());

    if (newCategory == 'Favorite') {
      await loadFavoritesFromPrefs();
      filteredLive = favoriteSeriesList.map((map) => MovieDetailModel.mapToMovie(map)).toList();
    } else if (newCategory == 'Recent View') {
      await loadRecentFromPrefs();
      filteredLive = recentSeriesList.map((map) => MovieDetailModel.mapToMovie(map)).toList();
    } else {
      await getAllLiveChannels(newCategory);
    }

    emit(ChangeCategoryState());

  }

  List<MovieDetailModel> allLive = [];
  List<MovieDetailModel> filteredLive = [];




  Future<void> getAllLiveChannels(String categoryName) async {
    await Future.delayed(Duration(milliseconds: 1));
    emit(MovieLoaded());

    final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_vod_streams';

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final List data = response.data;
       // print(response.data); // Log response data


        // Map the raw data into MovieDetailModel objects
        allLive = data.map<MovieDetailModel>((e) {
          // Safely extract the movie data and info, handle the cases where info is missing
          final movieData = Map<String, dynamic>.from(e);
          final info = Map<String, dynamic>.from(e['info'] ?? {});

          // Check if the movie image exists in info or fallback to stream_icon
          final movieImage = info['movie_image'] ?? e['stream_icon'] ?? '';
          final backImage = List<String>.from(info['backdrop_path'] ?? []);
          final genre = info['genre'] ?? '';
          final plot = info['plot'] ?? '';
          final cast = info['cast'] ?? '';
          final rating = info['rating'] ?? '';
          final containerExtension = info['containerExtension'] ?? '';







          return MovieDetailModel.fromJson({
            'movie_data': movieData,
            'info': {
              'movie_image': movieImage,
              'backdrop_path': backImage,
              'genre' : genre,
              'plot' : plot,
              'cast': cast ,
              'rating':rating,
              'containerExtension':containerExtension,
            },
          });
        }).toList();

        // Retrieve categoryId from categoryIdToNameMap based on categoryName
        final selectedId = categoryIdToNameMap.entries
            .firstWhere((entry) => entry.value == categoryName, orElse: () => MapEntry('', ''))
            .key;

        // Filter the movies by categoryId
        filteredLive = allLive.where((movie) => movie.categoryId == selectedId).toList();

        emit(GetMovieSuccessState());
      } else {
        log('Unexpected response format: ${response.data}');
        emit(MovieError('Unexpected response format'));
      }
    } catch (e) {
      final errorMsg = 'Error fetching live channels: $e';
      log(errorMsg);
      emit(MovieError(errorMsg));
    }
  }

  String getCategoryNameFromId(String categoryId) {
    return categoryIdToNameMap[categoryId] ?? 'Unknown';
  }


  // == Favorite local logic == //
  List<Map<String, String>> favoriteSeriesList = [];
  List<Map<String, String>> recentSeriesList = [];

// Method to check if a series is in the favorite list
  bool isSeriesFavorite(Map<String, String> series) {
    return favoriteSeriesList.any((item) => item['title'] == series['title']);
  }

  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('favorite_Movie') ?? [];

    favoriteSeriesList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      final Map<String, String> stringMap = decoded.map((key, value) =>
          MapEntry(key, value.toString()));
      return stringMap;
    }).toList();

    filteredLive = recentSeriesList.map((map) {
      return MovieDetailModel(
        movieImage: map['stream_icon'] ?? '',
        backdropPath: [],
        tmdbId: '',
        youtubeTrailer: '',
        genre: '',
        plot: map['plot'] ?? '',
        cast: '',
        rating: '',
        director: '',
        releaseDate: '',
        duration: '',
        durationSecs: 0,
        streamId: map['series_id'] ?? '',
        name: map['title'] ?? '',
        year: '',
        added: '',
        categoryId: map['category_id'] ?? '',
        containerExtension: '',
        customSid: null,
        directSource: '',
      );
    }).toList();

    emit(SuccessFavLoadState());
  }
  Future<void> toggleFavorite(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the series is already in the favorite list
    final exists = favoriteSeriesList.any((item) =>
    item['title'] == series['title']);

    // Add or remove from the favorite list
    if (exists) {
      // Remove the series from the favorite list
      favoriteSeriesList.removeWhere((item) =>
      item['title'] == series['title']);
    } else {
      // Add the series to the favorite list
      favoriteSeriesList.add(series);
    }

    // Store the updated list in SharedPreferences
    final encoded = favoriteSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favorite_Movie', encoded);

    // Emit a state change to notify the UI that the data has been updated
    emit(ChangeCategoryState());
  }



  /// recent viwed

  Future<void> loadRecentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('recent_Movie') ?? [];

    // Map saved list data to LiveStream objects
    recentSeriesList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      final Map<String, String> stringMap = decoded.map((key, value) {
        return MapEntry(key, value?.toString() ?? '');  // Ensure no null values
      });
      return stringMap;
    }).toList();

    // Debug print to see if the data is loaded correctly
    print("Loaded Recent: $recentSeriesList");

    // Convert to MovieDetailModel objects
    filteredLive = recentSeriesList.map((map) {
      return MovieDetailModel(
        movieImage: map['stream_icon'] ?? '',
        backdropPath: [],
        tmdbId: '',
        youtubeTrailer: '',
        genre: '',
        plot: map['plot'] ?? '',
        cast: '',
        rating: '',
        director: '',
        releaseDate: '',
        duration: '',
        durationSecs: 0,
        streamId: map['series_id'] ?? '',
        name: map['title'] ?? '',
        year: '',
        added: '',
        categoryId: map['category_id'] ?? '',
        containerExtension: '',
        customSid: null,
        directSource: '',
      );
    }).toList();

    emit(ChangeCategoryState()); // Trigger the state change to update the UI
  }

  // Add a new series to recent views
  Future<void> addToRecent(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the series is already in the recent list
    final exists = recentSeriesList.any((item) => item['title'] == series['title']);

    if (exists) {
      // Remove the series from its current position
      recentSeriesList.removeWhere((item) => item['title'] == series['title']);
    }

    // Add the series to the top of the recent list
    recentSeriesList.insert(0, series);

    // Limit to most recent 10 items
    if (recentSeriesList.length > 10) {
      recentSeriesList = recentSeriesList.sublist(0, 10);
    }

    // Store the updated list in SharedPreferences
    final encoded = recentSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('recent_Movie', encoded);

    // Optional: emit state update if you want to refresh the UI
    emit(ChangeCategoryState());
  }


  bool isDropdownOpen = false;
  void toggleDropdown() {
    emit(ToggleDropdownState());
  }

  // ====== Search LOGIC ======

  void searchMovies(String query) {
    if (query.isEmpty) {
      filteredLive = List.from(allLive);
    } else {
      filteredLive = allLive
          .where((movie) =>
          movie.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
   // log('the filter $filteredMovies');
    emit(SearchMoviesState(filteredLive));
  }


  /// details of movie ///
  Future<void> fetchMovieDetails(String streamId) async {
    final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_vod_info&vod_id=$streamId';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final jsonData = response.data;

        // Log the full response to see the structure
          log('Movie Details Response: ${jsonEncode(jsonData)}');

        if (jsonData != null && jsonData['info'] != null && jsonData['movie_data'] != null) {
          final movieDetail = MovieDetailModel.fromJson(jsonData);
          emit(MovieDetailsLoaded(movieDetail));

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
                ? 'https://image.tmdb.org/t/p/w500/$profilePath'
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





















  /*// ===== Placement LOGIC ===== //
  void reorderItems(int oldIndex, int newIndex) {
    if (filteredMovies.isEmpty || oldIndex == newIndex) return;

    if (oldIndex >= filteredMovies.length || newIndex >= filteredMovies.length) {
      return; // Prevent index errors
    }

    final item = filteredMovies.removeAt(oldIndex);
    filteredMovies.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);

    emit(MovieUpdatedState(List.from(filteredMovies))); // Update state correctly
  }*/



}