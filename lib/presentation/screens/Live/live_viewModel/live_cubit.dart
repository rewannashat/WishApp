import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../resources/routes-manager.dart';
import 'live_states.dart';

class LiveCubit extends Cubit<Set<int>> {
  LiveCubit() : super({});


  //== Fav Icon LOGIC ==//
  void toggleFavorite(int index) {
    if (state.contains(index)) {
      emit(Set.from(state)..remove(index));
    } else {
      emit(Set.from(state)..add(index));
    }
  }

  //== Category LOGIC ==//
  final List<String> categories = ['Bein Sport', 'Smart', 'Tv', 'LiveTv'];
  String selectedCategory = 'Bein Sport';

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(Set.from(state));
  }

  //== BottomNavBar LOGIC ==//
 // int selectedIndex = 0;
  /*void onItemTapped(int index) {
    selectedIndex = index;
    emit(Set.from(state));
  }*/


  }

