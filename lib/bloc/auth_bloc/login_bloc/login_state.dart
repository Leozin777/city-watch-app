abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginOpenLoadingState extends LoginState {}

class LoginCloseLoadingState extends LoginState {}

class LoginEmailEhObrigatorioState extends LoginState {}

class LoginSenhaEhObrigatorioState extends LoginState {}

class LoginFailureState extends LoginState {
  final String message;

  LoginFailureState({required this.message});
}

class LoginSuccessState extends LoginState {
}
