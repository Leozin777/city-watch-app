abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginOpenLoadingState extends LoginState {}

class LoginCloseLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}

class LoginSuccessState extends LoginState {
  final String token;

  LoginSuccessState(this.token);
}
