abstract class MovieState {}

class MovieInitial extends MovieState {}
class ChangeCategoryState extends MovieState {}

class FavoriteUpdated extends MovieState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}

class SearchMoviesState extends MovieState {
  final List<Map<String, String>> filteredMovies;
  SearchMoviesState(this.filteredMovies);
}

class MovieUpdatedState extends MovieState {
  final List<String> updatedMovie;
  MovieUpdatedState(this.updatedMovie);
}

