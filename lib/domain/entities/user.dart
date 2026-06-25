class User {
  final String id;
  final String email;
  final String? companyCode;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    this.companyCode,
    this.isAdmin = false,
  });
}