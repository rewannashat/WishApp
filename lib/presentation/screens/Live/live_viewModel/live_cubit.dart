import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish/presentation/screens/Live/live_viewModel/stream_model.dart';
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


  // Category Logic
  final List<String> categories = [];
  Map<String, String> categoryIdToNameMap = {};  // To map category_id to category_name
  String? selectedCategoryId;
  String? selectedCategoryName;
  bool isDropdownOpen = false;
  String? selectedCategory ;


/// get drowpdown list category
  Future<void> getLiveCategories() async {
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
      await loadFavoritesFromPrefs(); // Load the favorites from shared preferences
      filteredLive = favoriteLiveList
          .map((map) => LiveStream.fromJson(map)) // Map the map to LiveStream objects
          .toList();
    } else if (newCategory == 'Recent View') {
      await loadRecentFromPrefs(); // Load the recently viewed from shared preferences
      filteredLive = recentStreams
          .map((map) => LiveStream.fromJson(map)) // Map the map to LiveStream objects
          .toList();
    } else {
      await getAllLiveChannels(newCategory); // Fetch other categories from the API
    }

    emit(ChangeCategoryState()); // Emit a state to indicate the change is complete
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

  List<Map<String, dynamic>> recentStreams = [];





  void addToRecentStreams(Map<String, dynamic> stream) async {
    // Assuming you save `stream` in SharedPreferences
    // Example: Save stream data to SharedPreferences (You can adjust this logic as per your app's needs)
    final prefs = await SharedPreferences.getInstance();
    recentStreams.add(stream); // Add to the list

    // Optionally: Limit the recent streams to, e.g., 10
    if (recentStreams.length > 10) {
      recentStreams.removeAt(0); // Remove the first (oldest) stream
    }

    // Save recent streams to SharedPreferences
    prefs.setStringList('recent_streams', recentStreams.map((stream) => jsonEncode(stream)).toList());
  }
  Future<void> loadRecentStreams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? recentStreamStrings = prefs.getStringList('recent_live');

    if (recentStreamStrings != null) {
      // Convert List<dynamic> to List<Map<String, dynamic>>
      recentStreams = recentStreamStrings
          .map((streamString) => Map<String, dynamic>.from(jsonDecode(streamString)))
          .toList();
    }
  }







  // Pagination

  bool isLoading = false;




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
      final Map<String, String> stringMap = decoded.map((key, value) => MapEntry(key, value.toString()));
      return stringMap;
    }).toList();

    // Convert favorites to LiveStream objects
    filteredLive = favoriteLiveList.map((map) {
      return LiveStream(
        name: map['name'] ?? 'Untitled', // Assuming the 'title' field
        streamId: int.tryParse(map['series_id'] ?? '0') ?? 0, // Assuming 'series_id' is numeric
        thumbnail: map['stream_icon'], // Assuming 'cover' is the thumbnail field
        streamUrl: map['stream_url'], // Assuming 'stream_url' exists
        categoryId: map['categoryId'].toString(),
      );
    }).toList();

    emit(GetStreamsSuccessState());
  }





  Future<void> loadRecentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('recent_series') ?? [];

    recentLiveList = savedList.map((e) {
      final Map<String, dynamic> decoded = jsonDecode(e);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    emit(ChangeCategoryState());
  }

  Future<void> addToRecent(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();
    recentLiveList.removeWhere((item) => item['title'] == series['title']);
    recentLiveList.insert(0, series); // insert at beginning
    if (recentLiveList.length > 10) recentLiveList = recentLiveList.sublist(0, 10); // limit to 20
    final encoded = recentLiveList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('recent_series', encoded);
  }

  Future<void> toggleFavorite(Map<String, String> series) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the series is already in the favorite list
    final exists = favoriteLiveList.any((item) => item['title'] == series['title']);

    // Add or remove from the favorite list
    if (exists) {
      favoriteLiveList.removeWhere((item) => item['title'] == series['title']);
    } else {
      favoriteLiveList.add(series);
    }

    // Store the updated list in SharedPreferences
    final encoded = favoriteLiveList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('favorite_live', encoded);

    // Emit a state change to notify the UI
    emit(ChangeCategoryState());
  }
}
