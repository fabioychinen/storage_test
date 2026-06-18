import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/data/datasources/auth_local_data_source.dart';
import 'package:storage_test/data/models/user_model.dart';
import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User?> login(String username, String password) async {
    try {
      appLogger.i('Login: $username');
      final map = await _dataSource.queryUserByCredentials(username, password);
      if (map == null) return null;
      final user = UserModel.fromMap(map);
      await _dataSource.saveLoggedUserId(user.id!);
      return user;
    } catch (e) {
      appLogger.e('Erro ao fazer login', error: e);
      rethrow;
    }
  }

  @override
  Future<User> register(String username, String password) async {
    try {
      appLogger.i('Cadastro: $username');
      final id = await _dataSource.insertUser(
        UserModel(username: username, password: password).toMapWithoutId(),
      );
      final user = UserModel(id: id, username: username, password: password);
      await _dataSource.saveLoggedUserId(id);
      return user;
    } catch (e) {
      appLogger.e('Erro ao cadastrar usuário', error: e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    appLogger.i('Logout');
    await _dataSource.clearLoggedUserId();
  }

  @override
  Future<User?> getLoggedUser() async {
    try {
      final id = await _dataSource.getLoggedUserId();
      if (id == null) return null;
      final map = await _dataSource.queryUserById(id);
      if (map == null) return null;
      return UserModel.fromMap(map);
    } catch (e) {
      appLogger.e('Erro ao buscar usuário logado', error: e);
      return null;
    }
  }
}
