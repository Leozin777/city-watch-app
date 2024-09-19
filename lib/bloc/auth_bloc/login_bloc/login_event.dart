abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String senha;

  LoginButtonPressedEvent(this.email, this.senha);
}
