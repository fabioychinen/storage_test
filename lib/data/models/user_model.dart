import 'package:storage_test/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    required super.username,
    required super.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'username': username,
      'password': password,
    };
  }
}
