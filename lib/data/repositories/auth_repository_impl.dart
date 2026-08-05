import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/data/datasources/auth_supabase_data_source.dart';
import 'package:storage_test/data/models/user_model.dart';
import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthSupabaseDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User?> login(String email, String password) async {
    try {
      appLogger.i('Login: $email');
      final map = await _dataSource.signIn(email, password);
      if (map == null) return null;
      return UserModel.fromMap(map);
    } catch (e) {
      appLogger.e('Erro ao fazer login', error: e);
      rethrow;
    }
  }

  @override
  Future<User> register(String email, String password,
      {String? companyCode, String? companyName}) async {
    try {
      appLogger.i('Cadastro: $email');
      final map = await _dataSource.signUp(email, password,
          companyCode: companyCode, companyName: companyName);
      return UserModel.fromMap(map);
    } catch (e) {
      appLogger.e('Erro ao cadastrar usuário', error: e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    appLogger.i('Logout');
    await _dataSource.signOut();
  }

  @override
  Future<User?> getLoggedUser() async {
    try {
      final map = await _dataSource.getCurrentUser();
      if (map == null) return null;
      return UserModel.fromMap(map);
    } catch (e) {
      appLogger.e('Erro ao buscar usuário logado', error: e);
      return null;
    }
  }
}