import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish/presentation/screens/Live/live_viewModel/stream_model.dart';
import '../../../../domian/local/sharedPref.dart';
import 'fav_model.dart';
import 'live_model.dart';
import 'live_states.dart';

class LiveCubit extends Cubit<LiveStates> {
  LiveCubit() : super(InitialState());

  static LiveCubit get(context) => BlocProvider.of(context);


  final String baseUrl = "http://tgdns4k.com:8080/player_api.php";
  final String username = "6665e332412";
  final String password = "12977281747688";
  final dio = Dio();

    /// active playlist
  Future<String> _getBaseUrl() async {
    final baseUrl = await SharedPreferencesHelper.getData(key: 'activePlaylistUrl');
    return baseUrl ?? 'https://default.api.com'; // fallback URL
  }



  // Category Logic
  final List<String> categories = [];
  Map<String, String> categoryIdToNameMap = {};
  String? selectedCategoryId;
  String? selectedCategoryName;
  bool isDropdownOpen = false;
  String? selectedCategory ;


/// get drowpdown list category
  Future<void> getLiveCategories() async {

    // active playlist
  // final url = await SharedPreferencesHelper.getData(key: 'activePlaylistUrl');
  // final response = await dio.get('$url/player_api.php?username=xxx&password=yyy&action=...');


  final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_live_categories';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        categories.clear();
        categoryIdToNameMap.clear();
        categories.addAll(['Favorite', 'Recent View']); // Keep these as fallback categories

        for (var item in data) {
          final category = LiveCategory.fromJson(item);
          categoryIdToNameMap[category.categoryId] = category.categoryName;
          categories.add(category.categoryName);
        }



        // Automatically select the first item from the API response as the default category
        selectedCategory = categories.isNotEmpty ? categories[2] : ''; // Skipping 'Favorite' and 'Recent View'

        // ✅ Automatically filter series based on the first category
        changeCategory(selectedCategory!);

        emit(ChangeCategoryState());
      } else {
        log('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching live categories: $e');
    }
  }

  void changeCategory(String newCategory) async {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());

    if (newCategory == 'Favorite') {
      await loadFavoritesFromPrefs();
      filteredLive = favoriteLiveList.map((map) => LiveStream.mapToLiveStream(map)).toList();
    } else if (newCategory == 'Recent View') {
      await loadRecentFromPrefs();
      filteredLive = recentLiveList.map((map) => LiveStream.mapToLiveStream(map)).toList();
    } else {
      await getAllLiveChannels(newCategory);
    }

    emit(ChangeCategoryState());
  }

  void toggleDropdown() {
    emit(DropdownToggledState());
  }



  /// get the gridview data
  List<LiveStream> allLive = [];
  List<LiveStream> filteredLive = [];


  Future<void> getAllLiveChannels(String categoryName) async {
    final url =
        'http://tgdns4k.com:8080/player_api.php?username=$username&password=$password&action=get_live_streams';

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final List data = response.data;

      //  print(response.data);  // Check if stream_icon is present


        allLive = data.map<LiveStream>((e) {
          final enrichedData = {
            ...e,
            'categories': [getCategoryNameFromId(e['category_id']?.toString() ?? 'Unknown')],
          };
          Map<String, dynamic> validData = Map<String, dynamic>.from(enrichedData);
          return LiveStream.fromJson(validData);
        }).toList();

        final selectedId = categoryIdToNameMap.entries
            .firstWhere((entry) => entry.value == categoryName, orElse: () => MapEntry('', ''))
            .key;



        filteredLive = allLive.where((live) {
          return live.categoryId == selectedId;
        }).toList();


        emit(GetStreamsSuccessState());
      } else {
        log('Unexpected response format: ${response.data}');
        emit(GetStreamsErrorState('Unexpected response format'));
      }
    } catch (e) {
      final errorMsg = 'Error fetching live channels: $e';
      log(errorMsg);
      emit(GetStreamsErrorState(errorMsg));
    }
  }

  String getCategoryNameFromId(String categoryId) {
    return categoryIdToNameMap[categoryId] ?? 'Unknown';
  }


  /// fav
  // == Favorite local logic == //
  List<Map<String, String>> favoriteLiveList = [];
  List<Map<String, String>> recentLiveList = [];

// Method to check if a series is in the favorite list
  bool isSeriesFavorite(Map<String, dynamic> series) {
    return favoriteLiveList.any((item) => item['title'] == series['title']);
  }

  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('favorite_live') ?? [];

    // Map saved list data to LiveStream objects
    favoriteLiveList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      final Map<String, String> stringMap = decoded.map((key, value) {
        return MapEntry(key, value?.toString() ?? '');  // Ensure no null values
      });
      return stringMap;
    }).toList();

    // Debug print to see if the data is loaded correctly
    print("Loaded Favorites: $favoriteLiveList");

    // Convert favorites to LiveStream objects with default values for missing data
    filteredLive = favoriteLiveList.map((map) {
      return LiveStream(
        name: map['title'] ?? 'Untitled',  // Ensure non-null values
        streamId: int.tryParse(map['stream_id'] ?? '0') ?? 0,
        thumbnail: map['stream_icon'].toString() ?? 'default_image_url',
        streamUrl: map['stream_url'] ?? '',
        categoryId: map['category_id'] ?? 'Unknown',
      );
    }).toList();

    print("Loaded Favorites: $filteredLive");


    emit(GetStreamsSuccessState());
  }





  Future<void> toggleFavorite(Map<String, String?> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the series is already in the favorite list
    final exists = favoriteLiveList.any((item) => item['title'] == series['name']);

    // Add or remove from the favorite list
    if (exists) {
      favoriteLiveList.removeWhere((item) => item['title'] == series['name']);
    } else {
      // Ensure that no null values are passed in the map
      final updatedSeries = {
        'title': series['name'] ?? 'Unknown Title', // Fallback if title is null
        'stream_id': series['stream_id']?.toString() ?? '0', // Fallback if stream_id is null
        'stream_icon': series['stream_icon'] ?? 'default_image_url', // Provide a fallback image URL
        'stream_url': series['stream_url'] ?? '', // Fallback if stream_url is null
        'category_id': series['category_id'] ?? '', // Fallback if category_id is null
      };

      favoriteLiveList.add(updatedSeries);
    }

    // Store the updated list in SharedPreferences
    final encoded = favoriteLiveList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favorite_live', encoded);

    // Emit a state change to notify the UI
    emit(ChangeCategoryState());
  }

  // Load recent views from SharedPreferences
  Future<void> loadRecentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('recent_live') ?? [];

    // Map saved list data to LiveStream objects
    recentLiveList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      final Map<String, String> stringMap = decoded.map((key, value) {
        return MapEntry(key, value?.toString() ?? '');  // Ensure no null values
      });
      return stringMap;
    }).toList();

    // Debug print to see if the data is loaded correctly
    print("Loaded Recent: $recentLiveList");

    // Convert favorites to LiveStream objects with default values for missing data
    filteredLive = recentLiveList.map((map) {
      return LiveStream(
        name: map['title'] ?? 'Untitled',
        streamId: int.tryParse(map['stream_id'] ?? '0') ?? 0,
        thumbnail: map['stream_icon'].toString() ?? 'default_image_url',
        streamUrl: map['stream_url'] ?? '',
        categoryId: map['category_id'] ?? 'Unknown',
      );
    }).toList();

    emit(ChangeCategoryState()); // Trigger the state change to update the UI
  }

  // Add a new series to recent views
  Future<void> addToRecent(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert incoming map to a consistent format with 'name' key
    final updatedSeries = {
      'title': series['name'] ?? 'Unknown Title',
      'stream_id': series['stream_id']?.toString() ?? '0',
      'stream_icon': series['stream_icon'] ?? 'default_image_url',
      'stream_url': series['stream_url'] ?? '',
      'category_id': series['category_id'] ?? '',
    };

    // Remove if it already exists (by 'name')
    recentLiveList.removeWhere((item) => item['name'] == updatedSeries['title']);

    // Insert at the top
    recentLiveList.insert(0, updatedSeries);

    // Limit to most recent 10
    if (recentLiveList.length > 10) {
      recentLiveList = recentLiveList.sublist(0, 10);
    }

    // Save to SharedPreferences
    final encoded = recentLiveList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('recent_live', encoded);

    // Optional: emit state update if you want to refresh the UI
    emit(ChangeCategoryState());
  }






  void searchLive(String query) {
    if (query.isEmpty) {
      filteredLive = List.from(allLive);
    } else {
      filteredLive = allLive
          .where((stream) => stream.name
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
    emit(ChangeCategoryState());
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < 0 || newIndex < 0 || oldIndex >= filteredLive.length || newIndex >= filteredLive.length) return;

    final item = filteredLive.removeAt(oldIndex);
    filteredLive.insert(newIndex, item);
    emit(LiveUpdatedState(List.from(filteredLive)));
  }
}
