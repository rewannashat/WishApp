abstract class SeriesState {}

class SeriesInitial extends SeriesState {}
class ChangeCategoryState extends SeriesState {}

class ChangeCategorySeasonsState extends SeriesState {}

class FavoriteUpdated extends SeriesState {
  final Set<int> favorites;
  FavoriteUpdated(this.favorites);
}

class SearchSeriesState extends SeriesState {
  final List<Map<String, String>> filteredSeries;
  SearchSeriesState(this.filteredSeries);
}