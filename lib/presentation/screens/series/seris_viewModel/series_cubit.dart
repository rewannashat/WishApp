import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';


class SeriesCubit extends Cubit<SeriesState> {
  SeriesCubit() : super(SeriesInitial());

  static SeriesCubit get(context) => BlocProvider.of<SeriesCubit>(context);


  //== Category LOGIC ==//
  final List<String> categories = ['مسلسلات مصري 2022', 'مسلسلات رمضان 2024', 'مسلسلات رمضان 2025', 'مسلسلات مصري'];
  String selectedCategory = 'مسلسلات مصري 2022';



  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());
  }


  //== Category Details LOGIC ==//
  final List<String> categoriesDetails = ['Seasons1', 'Seasons2' , 'Seasons3' , 'Seasons4'];
  String selectedcategoriesDetails = 'Seasons1';

  void changeCategoryDetails(String newCategory) {
    selectedcategoriesDetails = newCategory;
    emit(ChangeCategorySeasonsState());
  }


  // ====== Search LOGIC ======
  List<String> allSeries = [
    'أشغال شاقة', 'كامل العدد', 'المداح','المداح5','المداح 3'
  ];
  List<String> filteredSeries = [];

  void searchSeries(String query) {
    if (query.isEmpty) {
      filteredSeries = List.from(allSeries);
    } else {
      filteredSeries = allSeries
          .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredSeries');
    emit(SearchSeriesState(filteredSeries));
  }


}