import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/routes-manager.dart';
import 'live_states.dart';

class LiveCubit extends Cubit<LiveStates> {
  LiveCubit() : super(InitialState());

  static LiveCubit get(context) => BlocProvider.of<LiveCubit>(context);

  //== Category LOGIC ==//
  final List<String> categories = ['Bein Sport', 'Smart', 'Tv', 'LiveTv','Link','LiveTv9'];
  String selectedCategory = 'Bein Sport';


  bool isDropdownOpen = false;

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());
  }

  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }


  // ====== Search LOGIC ======
  List<String> allLive = [
    'Bein Sport', 'Smart', 'Tv','LiveTv','LiveTv9','Link'
  ];
  List<String> filteredLive = [];

  void searchLive(String query) {
    if (query.isEmpty) {
      filteredLive = List.from(allLive);
    } else {
      filteredLive = allLive
          .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredLive');
    emit(SearchLiveState(filteredLive));
  }


  // ===== Placement LOGIC ===== //
  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < 0 || newIndex < 0 || oldIndex >= filteredLive.length || newIndex >= filteredLive.length) return;

    final item = filteredLive.removeAt(oldIndex); // Remove item (title + image)
    filteredLive.insert(newIndex, item); // Insert at new position

    emit(LiveUpdatedState(List.from(filteredLive))); // Emit updated state
  }




}
