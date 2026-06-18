abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;

  RegisterEvent({required this.username, required this.password});
}

class LogoutEvent extends AuthEvent {}
