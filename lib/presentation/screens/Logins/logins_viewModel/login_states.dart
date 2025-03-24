abstract class LoginState {}

class LoginInitial extends LoginState {}
class FetchDataSucessState extends LoginState {}
class FetchDataErrorState extends LoginState {
  final String error;
  FetchDataErrorState(this.error);
}


