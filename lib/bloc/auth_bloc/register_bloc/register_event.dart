abstract class RegisterEvent {}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterButtonPressedEvent({required this.name, required this.email, required this.password});
}
