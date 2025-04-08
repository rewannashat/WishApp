import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'live_states.dart';

class LiveCubit extends Cubit<LiveStates> {
  LiveCubit() : super(InitialState());

  static LiveCubit get(context) => BlocProvider.of(context);

  // == Category Logic ==
  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryId;
  String? selectedCategoryName;
  bool isDropdownOpen = false;

  // Pagination properties
  int currentPage = 1;
  final int pageSize = 50;
  bool isLoading = false;

  // Stream lists
  List<String> allLive = [];
  List<String> filteredLive = [];

  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }

  /// 🔄 Change selected category and fetch streams
  void changeCategory(Map<String, dynamic> category) {
    selectedCategoryId = category['category_id'];
    selectedCategoryName = category['category_name'];
    getLiveStreams(resetPagination: true); // Reset pagination when category changes
    emit(ChangeCategoryState());
  }

  /// 🌐 Fetch live categories from API
  void getLiveCategories() async {
    emit(GetCategoriesLoadingState());

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://tgdns4k.com:8080/player_api.php',
        queryParameters: {
          'username': '6665e332412',
          'password': '12977281747688',
          'action': 'get_live_categories',
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        categories = List<Map<String, dynamic>>.from(response.data);
      //  log('[LiveCategories] Fetched: $categories');

        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first['category_id'];
          selectedCategoryName = categories.first['category_name'];
          getLiveStreams();
        }

        emit(GetCategoriesSuccessState());
      } else {
        emit(GetCategoriesErrorState('Invalid category response format.'));
      }
    } catch (error) {
      log('[LiveCategories] Error: $error');
      emit(GetCategoriesErrorState('Failed to fetch categories: $error'));
    }
  }

  /// 📺 Get live streams for selected category (with pagination support)
  void getLiveStreams({bool resetPagination = false}) async {
    if (selectedCategoryId == null || isLoading) return;

    if (resetPagination) {
      currentPage = 1;
      allLive.clear(); // Reset the list when category changes
    }

    isLoading = true;
    emit(GetStreamsLoadingState());

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://tgdns4k.com:8080/player_api.php',
        queryParameters: {
          'username': '6665e332412',
          'password': '12977281747688',
          'action': 'get_live_streams',
          'category_id': selectedCategoryId,
          'page': currentPage,
          'page_size': pageSize,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> responseData = response.data;

        // Get the stream names from the response
        final List<String> newStreams = responseData
            .map<String>((item) => item['name'].toString())
            .toList();

        allLive.addAll(newStreams); // Add new streams to the list

        // Apply search filter if any
        filteredLive = allLive; // You can add custom filtering logic if needed

        currentPage++; // Increment page number for the next load
        emit(GetStreamsSuccessState());
      } else {
        emit(GetStreamsErrorState('Invalid streams response format.'));
      }
    } catch (error) {
      log('[LiveStreams] Error: $error');
      emit(GetStreamsErrorState('Failed to fetch streams: $error'));
    } finally {
      isLoading = false;
    }
  }

  /// 🔍 Search streams by name
  void searchLive(String query) {
    if (query.isEmpty) {
      filteredLive = [];
    } else {
      filteredLive = allLive
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(ChangeCategoryState());
  }

  /// 🔃 Reorder live items (optional feature)
  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < 0 || newIndex < 0 || oldIndex >= filteredLive.length || newIndex >= filteredLive.length) return;

    final item = filteredLive.removeAt(oldIndex);
    filteredLive.insert(newIndex, item);
    emit(LiveUpdatedState(List.from(filteredLive)));
  }
}
