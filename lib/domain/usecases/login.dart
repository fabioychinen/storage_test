import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository _repository;

  Login(this._repository);

  Future<User?> call(String email, String password) {
    return _repository.login(email, password);
  }
}
