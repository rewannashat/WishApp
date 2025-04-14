import 'package:chewie/chewie.dart';
import 'package:wish/presentation/screens/series/seris_viewModel/series_details_model.dart';

import 'cast_model.dart';

abstract class SeriesState {}

class SeriesInitial extends SeriesState {}

class ChangeCategoryState extends SeriesState {}

class CastLoadingState extends SeriesState {}
class CastLoadedState extends SeriesState {}

class SeriesLoadingState extends SeriesState {}

class SeriesSuccessState extends SeriesState {}

class SeriesErrorState extends SeriesState {
  final String error;

  SeriesErrorState(this.error);
}

class SeriesLoadedState extends SeriesState {
  final List<Map<String, String>> seriesList;

  SeriesLoadedState(this.seriesList);
}

class SeriesCastLoadedState extends SeriesState {
  final List<CastMemberModelSeries> castList;

  SeriesCastLoadedState(this.castList);
}

class SeriesDetailsLoadingState extends SeriesState {}

class GetSeriesSuccessState extends SeriesState {}

class SeriesDetailsSuccessState extends SeriesState {
  final Series seriesData;
  final Map<String, dynamic> rawJson;

  SeriesDetailsSuccessState(this.seriesData, this.rawJson);
}


class SeriesDetailsLoadedState extends SeriesState {
  final Series series;

  SeriesDetailsLoadedState(this.series);
}

class SeriesDetailsErrorState extends SeriesState {
  final String error;
  SeriesDetailsErrorState(this.error);
}

class ChangeCategorySeasonsState extends SeriesState {}

class FavoriteUpdated extends SeriesState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}

class SeriesSearchState extends SeriesState {
  final List<Map<String, String>> filteredSeries;
  SeriesSearchState(this.filteredSeries);
}


class SeriesPlayerLoade extends SeriesState {}
class SeriesPlayerLoaded extends SeriesState {
  final ChewieController chewieController;

  SeriesPlayerLoaded(this.chewieController);
}

class SeriesPlayerError extends SeriesState {
  final String error;

  SeriesPlayerError(this.error);
}

class MoviePlayerInitial extends SeriesState {}
class MoviePlayerChangeValu extends SeriesState {}