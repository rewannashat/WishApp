import '../../More/playList_viewModel/playList_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
class FetchDataLoadingState extends LoginState {}
class FetchDataSucessState extends LoginState {}
class FetchDataErrorState extends LoginState {
  final String error;
  FetchDataErrorState(this.error);
}

class AddPlayListLoadingState extends LoginState {}
class AddPlayListSucessState extends LoginState {
  final List<Playlist> playlists;

  AddPlayListSucessState(this.playlists);
}
class AddPlayListErrorState extends LoginState {
  final String error;
  AddPlayListErrorState(this.error);
}


class ActivePlayListLoadingState extends LoginState {}
class ActivePlayListSucessState extends LoginState {
  final List<Playlist> playlists;

  ActivePlayListSucessState(this.playlists);

  @override
  List<Object?> get props => [playlists];
}
class ActivePlayListErrorState extends LoginState {
  final String error;
  ActivePlayListErrorState(this.error);
}


class LoginTrialExpiredState extends LoginState {}



class GetPlayListLoadingState extends LoginState {}

class GetPlayListSucessState extends LoginState {
  final List<Playlist> playlists;

  GetPlayListSucessState({required this.playlists});
}

class GetPlayListErrorState extends LoginState {
  final String error;

  GetPlayListErrorState({required this.error});
}
