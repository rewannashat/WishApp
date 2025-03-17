import 'package:bloc/bloc.dart';


class MovieCubit extends Cubit<Set<int>> {
  MovieCubit() : super({});


  //== Fav Icon LOGIC ==//
  void toggleFavorite(int index) {
    if (state.contains(index)) {
      emit(Set.from(state)..remove(index));
    } else {
      emit(Set.from(state)..add(index));
    }
  }

  //== Category LOGIC ==//
  final List<String> categories = ['أفلام مصري 2022', 'أفلام مصري 2024', 'أفلام مصري 2025', 'أفلام مصري'];
  String selectedCategory = 'أفلام مصري 2022';

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(Set.from(state));
  }


}