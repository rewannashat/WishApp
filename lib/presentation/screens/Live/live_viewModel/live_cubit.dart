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
  final List<String> categories = ['Bein Sport', 'Smart', 'Tv', 'LiveTv'];
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

  void toggleDropdownn(bool isOpen) {
    isDropdownOpen = isOpen;
    emit(ChangeCategoryState());
  }

  // ====== Search LOGIC ======
  List<String> allLive = [
    'Bein Sport', 'Smart', 'Tv','LiveTv','LiveTv3','LiveTv','LiveTv3','LiveTv','LiveTv3'
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





}
