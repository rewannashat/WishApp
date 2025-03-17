import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit() : super(0);

  int get selectedIndex => state;

  void onItemTapped(BuildContext context, int index) {
    if (state != index) {
      emit(index);
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/live');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/movies');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/series');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/more');
          break;
      }
    }
  }
}
