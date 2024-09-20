abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterOpenLoadingState extends RegisterState {}

class RegisterCloseLoadingState extends RegisterState {}

class RegisterNomeEhObrigatorioState extends RegisterState {}

class RegisterEmailEhObrigatorioState extends RegisterState {}

class RegisterSenhaEhObrigatorioState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  final String message;

  RegisterFailureState({required this.message});
}

class RegisterSuccessState extends RegisterState {
  final String message;

  RegisterSuccessState({required this.message});
}
