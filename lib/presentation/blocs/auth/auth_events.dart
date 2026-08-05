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
  final String? companyName;

  RegisterEvent({
    required this.email,
    required this.password,
    this.companyCode,
    this.companyName,
  });
}

class LogoutEvent extends AuthEvent {}
