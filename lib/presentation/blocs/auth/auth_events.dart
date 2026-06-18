abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String? companyCode;

  RegisterEvent({
    required this.email,
    required this.password,
    this.companyCode,
  });
}

class LogoutEvent extends AuthEvent {}
