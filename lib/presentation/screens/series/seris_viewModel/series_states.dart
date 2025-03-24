abstract class SeriesState {}

class SeriesInitial extends SeriesState {}
class ChangeCategoryState extends SeriesState {}

class ChangeCategorySeasonsState extends SeriesState {}



class SearchSeriesState extends SeriesState {
  final List<String> filteredSeries;
  SearchSeriesState(this.filteredSeries);
}