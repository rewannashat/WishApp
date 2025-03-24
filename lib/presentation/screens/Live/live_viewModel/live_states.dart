abstract class LiveStates {}
class InitialState extends LiveStates {}

class ChangeCategoryState extends LiveStates {}


//== Fav Icon STATES ==//
class AddFavState extends LiveStates {}
class DeleteFavState extends LiveStates {}


class SearchLiveState extends LiveStates {
  final List<String> filteredLive;
  SearchLiveState(this.filteredLive);
}

