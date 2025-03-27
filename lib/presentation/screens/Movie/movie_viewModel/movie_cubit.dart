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

  List<Map<String, String>> get favoriteMovies =>
      _favorites.map((id) => allMovies[id]).toList();

  //== Category LOGIC ==//
  final List<String> categories = ['أفلام مصري 2022', 'أفلام مصري 2024', 'أفلام مصري 2025', 'أفلام مصري','Favorite'];
  String selectedCategory = 'أفلام مصري 2022';

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ChangeCategoryState());
  }

  // ====== Search LOGIC ======
  List<Map<String, String>> allMovies = [
    {
      'title': 'رحلة 404',
      'image': 'assets/images/movie.png',
    },
    {
      'title': 'ابو نسب',
      'image': 'assets/images/movieImage.png',
    },
    {
      'title': 'مقسوم',
      'image': 'assets/images/Rectangle.png',
    },
    {
      'title': 'المداح',
      'image': 'assets/images/movieImage.png',
    },
    {
      'title': 'المداح 2',
      'image': 'assets/images/movie.png',
    },
  ];

  List<Map<String, String>> filteredMovies = [];

  void searchMovies(String query) {
    if (query.isEmpty) {
      filteredMovies = List.from(allMovies);
    } else {
      filteredMovies = allMovies
          .where((movie) =>
          movie['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    log('the filter $filteredMovies');
    emit(SearchMoviesState(filteredMovies));
  }

  bool isDropdownOpen = false;
  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    emit(ChangeCategoryState());
  }

  // ===== Placement LOGIC ===== //
  void reorderItems(int oldIndex, int newIndex) {
    if (filteredMovies.isEmpty || oldIndex == newIndex) return;

    if (oldIndex >= filteredMovies.length || newIndex >= filteredMovies.length) {
      return; // Prevent index errors
    }

    final item = filteredMovies.removeAt(oldIndex);
    filteredMovies.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);

    emit(MovieUpdatedState(List.from(filteredMovies))); // Update state correctly
  }



}
