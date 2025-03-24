abstract class MovieState {}

class MovieInitial extends MovieState {}
class ChangeCategoryState extends MovieState {}

class FavoriteUpdated extends MovieState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}


class SearchMoviesState extends MovieState {
  final List<String> filteredMovies;
  SearchMoviesState(this.filteredMovies);
}