import 'package:chewie/chewie.dart';

import 'cast_model.dart';
import 'movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}
class ChangeCategoryState extends MovieState {}
/// drowpdown
class CategoryLoadedState extends MovieState {}
class ToggleDropdownState extends MovieState{}
class CategoryErrorState extends MovieState{
  final String error;
  CategoryErrorState(this.error);
}

class GetStreamsSuccessState extends MovieState{}




class MovieLoaded extends MovieState {}
class MovieError extends MovieState {}

/// gridview data
class MovieLoadingState extends MovieState {}
class MoviesSuccessState extends MovieState {}
class MovieErrorState extends MovieState {
  final String error;
  MovieErrorState(this.error);
}



class MovieSucessState extends MovieState {
  final MovieDetailModel movieDetail;
  final List<CastMemberModel> castMembers;

  MovieSucessState(this.movieDetail, this.castMembers);
}

class CastLoadingState extends MovieState {}
class CastLoadedState extends MovieState {}




class SeriesErrorState extends MovieState {
  final String error;

  SeriesErrorState(this.error);
}

class SeriesLoadedState extends MovieState {
  final List<Map<String, String>> seriesList;

  SeriesLoadedState(this.seriesList);
}


class GetStreamsErrorState extends MovieState {
  final String error;
  GetStreamsErrorState(this.error);
}




class FavoriteUpdated extends MovieState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}

class FavoriteLoadedState extends MovieState {
  final Set<int> favoriteMovieIds;
  FavoriteLoadedState(this.favoriteMovieIds);
}

class SearchMoviesState extends MovieState {
  final List filteredMovies;
  SearchMoviesState(this.filteredMovies);
}

class MovieUpdatedState extends MovieState {
  final List<String> updatedMovie;
  MovieUpdatedState(this.updatedMovie);
}

class MoviePlayerInitial extends MovieState {}
class MoviePlayerChangeValu extends MovieState {}

class MoviePlayerLoade extends MovieState {}
class MoviePlayerLoaded extends MovieState {
  final ChewieController chewieController;

  MoviePlayerLoaded(this.chewieController);
}

class MoviePlayerError extends MovieState {
  final String error;

  MoviePlayerError(this.error);
}
