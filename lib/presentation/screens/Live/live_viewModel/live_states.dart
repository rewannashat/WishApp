abstract class LiveStates {}
class InitialState extends LiveStates {}

class ChangeCategoryState extends LiveStates {}


//== Fav Icon STATES ==//
class FavoritesUpdatedState extends LiveStates {}
class DeleteFavState extends LiveStates {}
class DropdownToggledState extends LiveStates {}


class SearchLiveState extends LiveStates {
  final List<String> filteredLive;
  SearchLiveState(this.filteredLive);
}

class LiveUpdatedState extends LiveStates {
  final List<String> updatedLive;
  LiveUpdatedState(this.updatedLive);
}



class GetCategoriesLoadingState extends LiveStates {}
class GetCategoriesSuccessState extends LiveStates {}
class GetCategoriesErrorState extends LiveStates {
  final String error;
  GetCategoriesErrorState(this.error);
}


class LiveLoadingState extends LiveStates {}


class GetStreamsLoadingState extends LiveStates {}
class GetStreamsSuccessState extends LiveStates {}
class GetStreamsErrorState extends LiveStates {
  final String error;
  GetStreamsErrorState(this.error);
}