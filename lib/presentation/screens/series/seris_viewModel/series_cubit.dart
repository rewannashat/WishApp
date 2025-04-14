import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_details_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_model.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';

class SeriesCubit extends Cubit<SeriesState> {
  SeriesCubit() : super(SeriesInitial());

  static SeriesCubit get(context) => BlocProvider.of<SeriesCubit>(context);

  final String baseUrl = "http://tgdns4k.com:8080/player_api.php";
  final String username = "6665e332412";
  final String password = "12977281747688";

  // == Category LOGIC == //
  final List<String> categories = [];
  String selectedCategory = '';
  Map<String, String> categoryIdToNameMap = {};  // To map category_id to category_name

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
        categories.addAll(['Favorite', 'Recent View']); // Keep these as fallback categories

        for (var item in data) {
          final category = SeriesCategory.fromJson(item);
          categoryIdToNameMap[category.categoryId] = category.categoryName;
          categories.add(category.categoryName);
        }

        // Automatically select the first item from the API response as the default category
        selectedCategory = categories.isNotEmpty ? categories[2] : ''; // Skipping 'Favorite' and 'Recent View'

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



  Future<void> fetchSeriesForCategory(String categoryName) async {
    emit(SeriesLoadingState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_series',
      });

      if (response.statusCode == 200) {
        final List data = response.data;

        allSeries = data.map<Series>((e) {
          final enrichedData = {
            ...e,
            'categories': [getCategoryNameFromId(e['category_id']?.toString() ?? 'Unknown')],
          };
          Map<String, dynamic> validData = Map<String, dynamic>.from(enrichedData);
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
    emit(ChangeCategoryState());

    if (newCategory == 'Favorite') {
      await loadFavoritesFromPrefs();
      filteredSeries = favoriteSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else if (newCategory == 'Recent View') {
      await loadRecentFromPrefs();
      filteredSeries = favoriteSeriesList.map((map) => Series.mapToSeries(map)).toList();
    } else {
      await fetchSeriesForCategory(newCategory);
    }

    emit(ChangeCategoryState());
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
      final Map<String, String> stringMap = decoded.map((key, value) => MapEntry(key, value.toString()));
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
  /*Future<void> saveToFavorites(Series series) async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('favorite_series') ?? [];

    // Avoid duplicates
    if (favoriteSeriesList.any((item) => item['series_id'] == series.seriesId)) return;

    favoriteSeriesList.add(series.toMap());
    final updatedList = favoriteSeriesList.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList('favorite_series', updatedList);
    emit(ChangeCategoryState());
  }*/



  Future<void> loadRecentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('recent_series') ?? [];

    recentSeriesList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    emit(ChangeCategoryState());
  }

  Future<void> addToRecent(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();
    recentSeriesList.removeWhere((item) => item['title'] == series['title']);
    recentSeriesList.insert(0, series); // insert at beginning
    if (recentSeriesList.length > 10) recentSeriesList = recentSeriesList.sublist(0, 10); // limit to 20
    final encoded = recentSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('recent_series', encoded);
  }

  Future<void> toggleFavorite(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the series is already in the favorite list
    final exists = favoriteSeriesList.any((item) => item['title'] == series['title']);

    // Add or remove from the favorite list
    if (exists) {
      favoriteSeriesList.removeWhere((item) => item['title'] == series['title']);
    } else {
      favoriteSeriesList.add(series);
    }

    // Store the updated list in SharedPreferences
    final encoded = favoriteSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favorite_series', encoded);

    // Emit a state change to notify the UI
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

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;
        final info = data['info'] ?? {};
        final episodesMap = data['episodes'] ?? {};

        List episodeList = [];
        episodesMap.forEach((key, value) {
          if (value is List) {
            episodeList.addAll(value);
          }
        });

        final Map<String, dynamic> finalJson = {
          ...info,
          'series_id': seriesId,
          'episodes': episodeList,
        };

        currentSeriesDetails = Series.fromJson(finalJson);
        emit(SeriesDetailsLoadedState(currentSeriesDetails!));
      } else {
        emit(SeriesErrorState("Unexpected response format"));
      }
    } catch (e) {
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

  String selectedSeason = '';

  void changeSeason(String newSeason) {
    selectedSeason = newSeason;
    emit(ChangeCategorySeasonsState());
  }
}
