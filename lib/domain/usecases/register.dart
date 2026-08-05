import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository _repository;

  Register(this._repository);

  Future<User> call(String email, String password,
      {String? companyCode, String? companyName}) {
    return _repository.register(email, password,
        companyCode: companyCode, companyName: companyName);
  }
}