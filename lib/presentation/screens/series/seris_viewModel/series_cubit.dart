import 'package:bloc/bloc.dart';


class SeriesCubit extends Cubit<Set<int>> {
  SeriesCubit() : super({});


  //== Fav Icon LOGIC ==//
  void toggleFavorite(int index) {
    if (state.contains(index)) {
      emit(Set.from(state)..remove(index));
    } else {
      emit(Set.from(state)..add(index));
    }
  }

  //== Category LOGIC ==//
  final List<String> categories = ['مسلسلات مصري 2022', 'مسلسلات رمضان 2024', 'مسلسلات رمضان 2025', 'مسلسلات مصري'];
  String selectedCategory = 'مسلسلات مصري 2022';



  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(Set.from(state));
  }


  //== Category Details LOGIC ==//
  final List<String> categoriesDetails = ['Seasons1', 'Seasons2' , 'Seasons3' , 'Seasons4'];
  String selectedcategoriesDetails = 'Seasons1';

  void changeCategoryDetails(String newCategory) {
    selectedcategoriesDetails = newCategory;
    emit(Set.from(state));
  }

}