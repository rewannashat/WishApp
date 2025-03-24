import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wish/presentation/resources/constants/custom-staticwidget.dart';
import 'package:wish/presentation/screens/More/more_view.dart';
import 'package:wish/presentation/screens/Movie/movie_view.dart';
import 'package:wish/presentation/screens/Series/series_view.dart';

import '../Live/live_view.dart';
import 'bottomnav_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial());

  static BottomNavBarCubit get(context) => BlocProvider.of<BottomNavBarCubit>(context);


  // == Bottom Nav Bar LOGIC == //
  int currentIndex = 0;

  void changePage(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  final List<Widget> screens = [
    LiveView(),
    MovieView(),
    SeriesView(),
    MoreView(),
  ];

}