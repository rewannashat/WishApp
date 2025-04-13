import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    print('🔄 Fetching series categories...');
    emit(SeriesLoadingState());

    final url = baseUrl;
    final params = {
      'username': username,
      'password': password,
      'action': 'get_series_categories',
    };

    try {
      final response = await Dio().get(url, queryParameters: params);

    //  print('✅ API Response Status: ${response.statusCode}');
    //  print('API Response: ${jsonEncode(response.data)}');  // Log the full response

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

      /*  print('📦 Categories Raw Data Length: ${data.length}');
        for (int i = 0; i < data.length; i++) {
          print("📁 Category ${i + 1}: ${data[i]['category_name']}");
        }*/

        // Build the categories and category_id to name map
        final List<String> fetchedCategories = data
            .map((item) {
          final category = SeriesCategory.fromJson(item);
          categoryIdToNameMap[category.categoryId] = category.categoryName;
          return category.categoryName;
        })
            .toList();

        categories
          ..clear()
          ..addAll(['Favorite', 'Recent View', ...fetchedCategories]);

        selectedCategory = categories.first;

      /*  print('✅ Final Categories List:');
        for (final cat in categories) {
          print('🔹 $cat');
        }*/

        emit(ChangeCategoryState());
      } else {
        print('❌ Failed to load categories. Status code: ${response.statusCode}');
        emit(SeriesErrorState('Failed to load categories'));
      }
    } catch (e) {
      print('❗ Exception while fetching categories: $e');
      emit(SeriesErrorState(e.toString()));
    }
  }

  // == Gridview data logic == //
  /*List<Map<String, String>> allSeries = [];
  List<Map<String, String>> filteredSeries = [];*/
  List<Series> allSeries = [];
  List<Series> filteredSeries = [];


  /* Future<void> fetchSeriesForCategory(String categoryName) async {
    print('🔄 Fetching series for category: $categoryName');
    emit(SeriesLoadingState());

    try {
      final response = await Dio().get(baseUrl, queryParameters: {
        'username': username,
        'password': password,
        'action': 'get_series',
      });

    //  print('✅ API Response Status: ${response.statusCode}');
    //  print('API Response: ${jsonEncode(response.data)}');  // Log the full response

      if (response.statusCode == 200) {
        final List data = response.data;

       *//* // Log the response data to check the structure
        for (var series in data) {
          print('Series Data: ${jsonEncode(series)}');
        }*//*

        allSeries = data.map((e) => {
          'title': e['name']?.toString() ?? '',
          'image': e['cover']?.toString() ?? '',
          'category_name': getCategoryNameFromId(e['category_id']?.toString() ?? 'Unknown'),
        }).toList();

     //   print('📚 All series loaded: ${allSeries.length} items');

        // Filter series based on category name
        filteredSeries = allSeries
            .where((item) => item['category_name'] == categoryName)
            .toList();

     //   print('🔍 Filtered series for "$categoryName": ${filteredSeries.length} items');

        emit(SeriesSuccessState());
      } else {
        print('❌ API Error: Status ${response.statusCode}');
        emit(SeriesErrorState("Failed to load series"));
      }
    } catch (e) {
      print('❗ Exception: $e');
      emit(SeriesErrorState(e.toString()));
    }
  }*/

  Future<void> fetchSeriesForCategory(String categoryName) async {
    print('🔄 Fetching series for category: $categoryName');
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
          // Add category name to the data manually before parsing
          final enrichedData = {
            ...e,
            'categories': [getCategoryNameFromId(e['category_id']?.toString() ?? 'Unknown')],
          };

          // Convert enrichedData into a Map<String, dynamic> before passing to Series.fromJson
          Map<String, dynamic> validData = Map<String, dynamic>.from(enrichedData);

          final series = Series.fromJson(validData);

         /* // 🔍 Print episode titles or count
          print('📺 Series: ${series.title} has ${series.episodes.length} episodes');
          for (var ep in series.episodes) {
            print('   • ${ep.title}');
          }*/

          return series;
        }).toList();




        filteredSeries = allSeries.where((series) {
          return series.categories.contains(categoryName);
        }).toList();

        emit(SeriesSuccessState());
      } else {
        print('❌ API Error: Status ${response.statusCode}');
        emit(SeriesErrorState("Failed to load series"));
      }
    } catch (e) {
      print('❗ Exception: $e');
      emit(SeriesErrorState(e.toString()));
    }
  }


  void debugEpisodes(Series series) {
    int episodeCount = series.episodes.isNotEmpty ? series.episodes.length : 1;  // Handle the case if episodes list is empty
    print("Number of episodes: $episodeCount"); // Print the number of episodes
    print("Episodes List: ${series.episodes}"); // Print the list of episodes
  }


  String getCategoryNameFromId(String categoryId) {
    // Return the category name using the category_id
    return categoryIdToNameMap[categoryId] ?? 'Unknown';
  }

  void changeCategory(String newCategory) async {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());  // Emit state to notify UI

    if (newCategory == 'Favorite') {
      loadFavoritesFromPrefs();  // Load favorite series from SharedPreferences
    } else if (newCategory == 'Recent View') {
      loadRecentFromPrefs();// Load recent series from SharedPreferences
    } else {
      // Fetch series for the selected category
      await fetchSeriesForCategory(newCategory);
      emit(ChangeCategoryState());  // Emit state to notify UI
    }

    emit(ChangeCategoryState());  // Emit state to notify UI
  }

  // == Favorite local logic == //
  List<Map<String, String>> favoriteSeriesList = [];
  List<Map<String, String>> recentSeriesList = [];

  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('favorite_series') ?? [];

    favoriteSeriesList = savedList.map((e) => jsonDecode(e) as Map<String, String>).toList();
    emit(ChangeCategoryState());
  }

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
    if (recentSeriesList.length > 20) recentSeriesList = recentSeriesList.sublist(0, 20); // limit to 20
    final encoded = recentSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('recent_series', encoded);
  }

  Future<void> toggleFavorite(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();
    final exists = favoriteSeriesList.any((item) => item['title'] == series['title']);
    if (exists) {
      favoriteSeriesList.removeWhere((item) => item['title'] == series['title']);
    } else {
      favoriteSeriesList.add(series);
    }
    final encoded = favoriteSeriesList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favorite_series', encoded);
  }



  /// Method to fetch series details and episodes by series_id
  Series? currentSeriesDetails;

  Future<void> getSeriesDetails(String seriesId) async {
    try {
      final response = await Dio().get(
        'http://tgdns4k.com:8080/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_series_info',
          'series_id': seriesId,
        },
      );

      print("Request URL: ${response.requestOptions.uri}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;

        // Merge the fields from 'info' and add 'episodes'
        final info = data['info'] ?? {};
        final episodesMap = data['episodes'] ?? {};

        // Convert episode map (grouped by seasons/episode numbers) to flat list
        List episodeList = [];
        episodesMap.forEach((key, value) {
          if (value is List) {
            episodeList.addAll(value);
          }
        });

        // Build final JSON structure to feed to Series model
        final Map<String, dynamic> finalJson = {
          ...info,
          'series_id': seriesId,
          'episodes': episodeList,
        };

        // Now decode using your model
        currentSeriesDetails = Series.fromJson(finalJson);

        emit(SeriesDetailsLoadedState(currentSeriesDetails!));
      } else {
        emit(SeriesErrorState("Unexpected response format"));
      }
    } catch (e) {
      print("Error: $e");
      emit(SeriesErrorState("Failed to fetch series details"));
    }
  }



  // == Category Details LOGIC == //
  final List<String> categoriesDetails = ['Seasons1', 'Seasons2' , 'Seasons3' , 'Seasons4','Favorite'];
  String selectedcategoriesDetails = 'Seasons1';

  void changeCategoryDetails(String newCategory) {
    selectedcategoriesDetails = newCategory;
    emit(ChangeCategorySeasonsState());
  }

  // == Favorite LOGIC == //
 /* final Set<int> _favorites = {};

  bool isFavorite(int seriesId) {
    return _favorites.contains(seriesId);
  }

  List<Map<String, String>> get favoriteSeries =>
      _favorites.map((id) => allSeries[id]).toList();*/

  // ====== Search LOGIC ====== //
  void searchSeries(String query) {
    if (query.isEmpty) {
      filteredSeries = List.from(allSeries);
    } else {
      filteredSeries = allSeries
          .where((movie) =>
          movie.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredSeries');
   // emit(SearchSeriesState(filteredSeries));
  }

  bool isDropdownOpen = false;
  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }
}
