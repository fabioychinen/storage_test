import 'package:storage_test/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.companyCode,
    super.isAdmin,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      companyCode: map['company_code'] as String?,
      isAdmin: map['is_admin'] as bool? ?? false,
    );
  }
}