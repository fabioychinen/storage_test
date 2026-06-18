import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';

class GetLoggedUser {
  final AuthRepository _repository;

  GetLoggedUser(this._repository);

  Future<User?> call() {
    return _repository.getLoggedUser();
  }
}
