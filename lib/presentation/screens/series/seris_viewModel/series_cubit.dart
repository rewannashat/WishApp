import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_states.dart';


class SeriesCubit extends Cubit<SeriesState> {
  SeriesCubit() : super(SeriesInitial());

  static SeriesCubit get(context) => BlocProvider.of<SeriesCubit>(context);


  //== Category LOGIC ==//
  final List<String> categories = ['مسلسلات مصري 2022', 'مسلسلات رمضان 2024', 'مسلسلات رمضان 2025', 'مسلسلات مصري','Favorite'];
  String selectedCategory = 'مسلسلات مصري 2022';



  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());
  }



  //== Category Details LOGIC ==//
  final List<String> categoriesDetails = ['Seasons1', 'Seasons2' , 'Seasons3' , 'Seasons4','Favorite'];
  String selectedcategoriesDetails = 'Seasons1';

  void changeCategoryDetails(String newCategory) {
    selectedcategoriesDetails = newCategory;
    emit(ChangeCategorySeasonsState());
  }

  //== Favorite LOGIC ==//
  final Set<int> _favorites = {};

  void toggleFavorite(int seriesId) {
    if (_favorites.contains(seriesId)) {
      _favorites.remove(seriesId);
    } else {
      _favorites.add(seriesId);
    }
    emit(FavoriteUpdated(Set<int>.from(_favorites)));
  }

  bool isFavorite(int seriesId) {
    return _favorites.contains(seriesId);
  }

  List<Map<String, String>> get favoriteSeries =>
      _favorites.map((id) => allSeries[id]).toList();


  // ====== Search LOGIC ======

  List<Map<String, String>> allSeries = [
    {
      'title': 'أشغال شاقة',
      'image': 'assets/images/series.png',
    },
    {
      'title': 'كامل العدد',
      'image': 'assets/images/rrr.png',
    },
    {
      'title': 'المداح',
      'image': 'assets/images/g.png',
    },
    {
      'title': 'المداح5',
      'image': 'assets/images/rrr.png',
    },
    {
      'title': 'المداح 2',
      'image': 'assets/images/series.png',
    },
  ];
  List<Map<String, String>> filteredSeries = [];

  void searchSeries(String query) {
    if (query.isEmpty) {
      filteredSeries = List.from(allSeries);
    } else {
      filteredSeries = allSeries
          .where((movie) =>
          movie['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredSeries');
    emit(SearchSeriesState(filteredSeries));
  }


  bool isDropdownOpen = false;
  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }


}