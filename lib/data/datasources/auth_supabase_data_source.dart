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
    final profile = await _fetchProfile(user.id);
    return {
      'id': user.id,
      'email': user.email ?? email,
      'company_code': profile?['company_code'],
      'is_admin': profile?['is_admin'] ?? false,
    };
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
    final bool isAdmin;

    if (companyCode != null && companyCode.isNotEmpty) {
      final company = await _client
          .from('companies')
          .select('id, code')
          .eq('code', companyCode.toUpperCase())
          .maybeSingle();
      if (company == null) throw Exception('Código de empresa inválido');
      companyId = company['id'] as String;
      resolvedCode = company['code'] as String;
      isAdmin = false;
    } else {
      resolvedCode = _generateCode();
      final company = await _client.from('companies').insert({
        'name': email.split('@').first,
        'code': resolvedCode,
      }).select('id').single();
      companyId = company['id'] as String;
      isAdmin = true; // criador da empresa é admin
    }

    await _client.from('profiles').insert({
      'id': user.id,
      'company_id': companyId,
      'is_admin': isAdmin,
    });

    return {
      'id': user.id,
      'email': user.email ?? email,
      'company_code': resolvedCode,
      'is_admin': isAdmin,
    };
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final profile = await _fetchProfile(user.id);
    return {
      'id': user.id,
      'email': user.email ?? '',
      'company_code': profile?['company_code'],
      'is_admin': profile?['is_admin'] ?? false,
    };
  }

  Future<Map<String, dynamic>?> _fetchProfile(String userId) async {
    try {
      final result = await _client
          .from('profiles')
          .select('is_admin, companies(code)')
          .eq('id', userId)
          .single();
      return {
        'is_admin': result['is_admin'] as bool? ?? false,
        'company_code': result['companies']?['code'] as String?,
      };
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