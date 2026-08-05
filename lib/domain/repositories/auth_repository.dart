import 'package:storage_test/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User> register(String email, String password,
      {String? companyCode, String? companyName});
  Future<void> logout();
  Future<User?> getLoggedUser();
}