import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  static MovieCubit get(context) => BlocProvider.of<MovieCubit>(context);

  //== Favorite LOGIC ==//
  final Set<int> _favorites = {};

  void toggleFavorite(int movieId) {
    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    emit(FavoriteUpdated(Set<int>.from(_favorites)));
  }

  bool isFavorite(int movieId) {
    return _favorites.contains(movieId);
  }

  List<String> get favoriteMovies => _favorites.map((id) => allMovies[id]).toList();

  //== Category LOGIC ==//
  final List<String> categories = ['أفلام مصري 2022', 'أفلام مصري 2024', 'أفلام مصري 2025', 'أفلام مصري','Favorite'];
  String selectedCategory = 'أفلام مصري 2022';

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());
  }

  // ====== Search LOGIC ======
  List<String> allMovies = [
    'رحلة 404', 'ابو نسب', 'مقسوم','المداح','المداح 2'
  ];
  List<String> filteredMovies = [];

  void searchMovies(String query) {
    if (query.isEmpty) {
      filteredMovies = List.from(allMovies);
    } else {
      filteredMovies = allMovies
          .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredMovies');
    emit(SearchMoviesState(filteredMovies));
  }
}
