abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String senha;

  LoginButtonPressedEvent({required this.email, required this.senha});
}
