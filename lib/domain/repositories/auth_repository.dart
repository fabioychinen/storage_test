import 'package:storage_test/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<User> register(String username, String password);
  Future<void> logout();
  Future<User?> getLoggedUser();
}
