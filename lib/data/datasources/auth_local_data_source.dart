import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_test/data/datasources/database_helper.dart';

const _loggedUserKey = 'logged_user_id';

class AuthLocalDataSource {
  Future<Map<String, dynamic>?> queryUserByCredentials(
    String username,
    String password,
  ) async {
    final db = await DatabaseHelper.db;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> queryUserById(int id) async {
    final db = await DatabaseHelper.db;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUser(Map<String, dynamic> values) async {
    final db = await DatabaseHelper.db;
    return db.insert('users', values);
  }

  Future<void> saveLoggedUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loggedUserKey, id);
  }

  Future<int?> getLoggedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_loggedUserKey);
  }

  Future<void> clearLoggedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedUserKey);
  }
}