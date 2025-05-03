import 'package:chewie/chewie.dart';

import 'cast_model.dart';
import 'movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}
class ChangeCategoryState extends MovieState {}

class CategoryLoadedState extends MovieState {}
class ToggleDropdownState extends MovieState{}
class CategoryErrorState extends MovieState{}


class MovieLoaded extends MovieState {}
class GetMovieSuccessState extends MovieState {}
class MovieError extends MovieState {
  final String error;
  MovieError(this.error);
}


class MovieLoadingState extends MovieState {}
class MovieSucessState extends MovieState {
  final MovieDetailModel movieDetail;
  final List<CastMemberModel> castMembers;

  MovieSucessState(this.movieDetail, this.castMembers);
}

class CastLoadingState extends MovieState {}
class CastLoadedState extends MovieState {}

class MovieErrorState extends MovieState {
  final String error;
  MovieErrorState(this.error);
}

class MovieDetailsLoaded extends MovieState {
  final MovieDetailModel movieDetail;

  MovieDetailsLoaded(this.movieDetail);
}



class FavoriteUpdated extends MovieState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}

class SearchMoviesState extends MovieState {
  final List<MovieDetailModel> filteredMovies;
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

class SuccessFavLoadState extends MovieState {}
