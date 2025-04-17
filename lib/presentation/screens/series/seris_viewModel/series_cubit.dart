import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/person_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_details_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';

import '../../Movie/movie_viewModel/cast_model.dart';
import 'cast_model.dart';

class SeriesCubit extends Cubit<SeriesState> {
  SeriesCubit() : super(SeriesInitial());

  static SeriesCubit get(context) => BlocProvider.of<SeriesCubit>(context);

  final String baseUrl = "http://tgdns4k.com:8080/player_api.php";
  final String username = "6665e332412";
  final String password = "12977281747688";

  // == Category LOGIC == //
  final List<String> categories = [];
  String selectedCategory = '';
  Map<String, String> categoryIdToNameMap = {
  }; // To map category_id to category_name

  Future<void> getSeriesCategories() async {
    emit(SeriesLoadingState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_series_categories',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        categories.clear();
        categoryIdToNameMap.clear();
        categories.addAll(
            ['Favorite', 'Recent View']); // Keep these as fallback categories

        for (var item in data) {
          final category = SeriesCategory.fromJson(item);
          categoryIdToNameMap[category.categoryId] = category.categoryName;
          categories.add(category.categoryName);
        }

        // Automatically select the first item from the API response as the default category
        selectedCategory = categories.isNotEmpty
            ? categories[2]
            : ''; // Skipping 'Favorite' and 'Recent View'

        // ✅ Automatically filter series based on the first category
        changeCategory(selectedCategory!);

        emit(ChangeCategoryState());
      } else {
        emit(SeriesErrorState('Failed to load categories'));
      }
    } catch (e) {
      emit(SeriesErrorState(e.toString()));
    }
  }

  // == Gridview data logic == //
  List<Series> allSeries = [];
  List<Series> filteredSeries = [];
  List<Episode> alleposids = [];



  Future<void> fetchSeriesForCategory(String categoryName) async {
    await Future.delayed(Duration(milliseconds: 1));
    emit(SeriesLoadingState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_series',
      });

      // Print the response for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Data Series: ${response.data}");

      if (response.statusCode == 200) {
        final List data = response.data;

        allSeries = data.map<Series>((e) {
          final enrichedData = {
            ...e,
            'categories': [
              getCategoryNameFromId(e['category_id']?.toString() ?? 'Unknown')
            ],
          };
          Map<String, dynamic> validData = Map<String, dynamic>.from(
              enrichedData);
          return Series.fromJson(validData);
        }).toList();

        filteredSeries = allSeries.where((series) {
          return series.categories.contains(categoryName);
        }).toList();

        emit(SeriesSuccessState());
      } else {
        emit(SeriesErrorState("Failed to load series"));
      }
    } catch (e) {
      emit(SeriesErrorState(e.toString()));
    }
  }

  String getCategoryNameFromId(String categoryId) {
    return categoryIdToNameMap[categoryId] ?? 'Unknown';
  }

  void changeCategory(String newCategory) async {
    selectedCategory = newCategory;
    emit(SeriesLoadingState());  // Emit loading state

    if (newCategory == 'Favorite') {
      await loadFavoritesFromPrefs();
      filteredSeries = favoriteSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else if (newCategory == 'Recent View') {
      await loadRecentFromPrefs();
      filteredSeries = recentSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else {
      await fetchSeriesForCategory(newCategory);
    }

    emit(ChangeCategoryState());  // Emit state after data is loaded
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
    final savedList = prefs.getStringList('favorite_series') ?? [];

    favoriteSeriesList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      final Map<String, String> stringMap = decoded.map((key, value) =>
          MapEntry(key, value.toString()));
      return stringMap;
    }).toList();

    // Convert favorites to Series
    filteredSeries = favoriteSeriesList.map((map) {
      return Series(
        title: map['title'] ?? '',
        imageUrl: map['cover'] ?? '',
        description: map['description'] ?? '',
        cast: [],
        episodes: [],
        seriesId: map['series_id'] ?? '',
        categories: ['Favorite'],
        genre: [],
        rating: '',
        seasons: [],
      );
    }).toList();

    emit(SeriesSuccessState());
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
    await prefs.setStringList('favorite_series', encoded);

    // Emit a state change to notify the UI that the data has been updated
    emit(ChangeCategoryState());
  }



/// recent viwed

  Future<void> loadRecentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('recent_series') ?? [];

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

    // Convert favorites to LiveStream objects with default values for missing data
    filteredSeries = recentSeriesList.map((map) {
      return Series(
        title: map['title'] ?? '',
        imageUrl: map['cover'] ?? '',
        description: map['description'] ?? '',
        cast: [],
        episodes: [],
        seriesId: map['series_id'] ?? '',
        categories: ['Favorite'],
        genre: [],
        rating: '',
        seasons: [],
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
    await prefs.setStringList('recent_series', encoded);

    // Optional: emit state update if you want to refresh the UI
    emit(ChangeCategoryState());
  }



  /// Method to fetch series details by series_id
  Series? currentSeriesDetails;

  Future<void> getSeriesDetails(String seriesId) async {
    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_series_info',
        'series_id': seriesId,
      });

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;

        final info = data['info'] ?? {};
        final episodesMap = data['episodes'] ?? {};

        // ⭐️ طباعة وفحص الحلقات حسب المواسم
        if (episodesMap is Map<String, dynamic>) {
          episodesMap.forEach((season, episodes) {
            print("📺 Season $season:");

            if (episodes is List) {
              for (var ep in episodes) {
                print("➡️ Episode: ${ep['title'] ?? ''}, ID: ${ep['id']}, Num: ${ep['episode_num']}");
              }
            } else {
              print("❌ Season $season is not a list of episodes.");
            }
          });

          // ⭐️ استدعاء الميثود لتخزين الحلقات المصنّفة
          setEpisodes(episodesMap);
        } else {
          print("⚠️ Episodes map is not in expected format.");
        }

        // لإنشاء Series، راح ندمج كل الحلقات في قائمة وحدة (لو محتاجينها في الشاشة)
        List episodeList = [];
        episodesMap.forEach((_, episodes) {
          if (episodes is List) episodeList.addAll(episodes);
        });

        final Map<String, dynamic> finalJson = {
          ...info,
          'series_id': seriesId,
          'episodes': episodeList,
        };

        currentSeriesDetails = Series.fromJson(finalJson);

        emit(SeriesDetailsLoadedState(currentSeriesDetails!));
      } else {
        print("⚠️ Unexpected response format");
        emit(SeriesErrorState("Unexpected response format"));
      }
    } catch (e) {
      print("❌ Error fetching series details: $e");
      emit(SeriesErrorState("Failed to fetch series details"));
    }
  }

  // == Search Logic == //
  void searchSeries(String query) {
    if (query.isEmpty) {
      filteredSeries = List.from(allSeries);
    } else {
      filteredSeries = allSeries
          .where((movie) =>
          movie.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  bool isDropdownOpen = false;

  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }

  String selectedSeason = '1';

  void changeSeason(String newSeason) {
    selectedSeason = newSeason;
    emit(ChangeCategorySeasonsState());
  }


  Future<List<CastMemberModel>> fetchCastData(List<String> arrCast) async {
    final apiKey = '6c4fc80fb22f43f77d2ed3f68b5ef57f';
    List<CastMemberModel> castMembers = [];

    final futures = arrCast.map((name) async {
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

            // Collect all known_for images
            List<String> knownForImages = [];
            final knownFor = actor['known_for'] ?? [];
            for (var show in knownFor) {
              final showPosterPath = show['poster_path'];
              if (showPosterPath != null) {
                knownForImages.add('https://image.tmdb.org/t/p/w500$showPosterPath');
              }
            }

            // Create CastMemberModel with all known images
            return CastMemberModel(name: name, profileImage: profileImage, );
          }
        }
      } catch (e) {
        print('Error fetching $name: $e');
      }
      return CastMemberModel(name: name, profileImage: '',); // fallback
    }).toList();

    // Wait for all requests to complete
    final results = await Future.wait(futures);
    castMembers.addAll(results);

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

    emit(SeriesPlayerLoade());

    try {
      final movieUrl =
          'http://tgdns4k.com:8080/series/$username/$password/$streamId.$extension';

      final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(movieUrl));

      await videoPlayerController.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
      );

      emit(SeriesPlayerLoaded(chewieController!));
    } catch (e) {
      emit(SeriesPlayerError("Failed to load video: $e"));
    }
  }


  void disposePlayer() {
    chewieController?.dispose();
    chewieController = null;
  }


  Map<String, List<Episode>> groupedEpisodes = {};

  void setEpisodes(Map<String, dynamic> episodesMap) {
    groupedEpisodes.clear();
    episodesMap.forEach((season, episodesList) {
      groupedEpisodes[season] = (episodesList as List)
          .map((e) => Episode.fromJson(e))
          .toList();
    });
    emit(SeasonsGroupedState());
  }


/// handle error api logic
  Future<void> refreshSeries() async {
    emit(SeriesLoadingState());

    if (selectedCategory == 'Favorite') {
      await loadFavoritesFromPrefs();
      filteredSeries = favoriteSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else if (selectedCategory == 'Recent View') {
      await loadRecentFromPrefs();
      filteredSeries = recentSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else {
      await fetchSeriesForCategory(selectedCategory);
    }

    emit(ChangeCategoryState());
  }



}