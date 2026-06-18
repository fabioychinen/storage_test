import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSupabaseDataSource {
  final _auth = Supabase.instance.client.auth;
  SupabaseClient get _client => Supabase.instance.client;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) return null;
    final companyCode = await _fetchCompanyCode(user.id);
    return {'id': user.id, 'email': user.email ?? email, 'company_code': companyCode};
  }

  Future<Map<String, dynamic>> signUp(
    String email,
    String password, {
    String? companyCode,
  }) async {
    final response = await _auth.signUp(email: email, password: password);
    final user = response.user;
    if (user == null) throw Exception('Erro ao criar conta');

    String companyId;
    String? resolvedCode;

    if (companyCode != null && companyCode.isNotEmpty) {
      final company = await _client
          .from('companies')
          .select('id, code')
          .eq('code', companyCode.toUpperCase())
          .maybeSingle();
      if (company == null) throw Exception('Código de empresa inválido');
      companyId = company['id'] as String;
      resolvedCode = company['code'] as String;
    } else {
      resolvedCode = _generateCode();
      final company = await _client.from('companies').insert({
        'name': email.split('@').first,
        'code': resolvedCode,
      }).select('id').single();
      companyId = company['id'] as String;
    }

    await _client.from('profiles').insert({
      'id': user.id,
      'company_id': companyId,
    });

    return {
      'id': user.id,
      'email': user.email ?? email,
      'company_code': resolvedCode,
    };
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final companyCode = await _fetchCompanyCode(user.id);
    return {'id': user.id, 'email': user.email ?? '', 'company_code': companyCode};
  }

  Future<String?> _fetchCompanyCode(String userId) async {
    try {
      final result = await _client
          .from('profiles')
          .select('companies(code)')
          .eq('id', userId)
          .single();
      return result['companies']?['code'] as String?;
    } catch (_) {
      return null;
    }
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
