import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSupabaseDataSource {
  final _auth = Supabase.instance.client.auth;
  SupabaseClient get _client => Supabase.instance.client;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) return null;
    // Fetch profile via edge function now that session is established
    final profileResponse = await _client.functions.invoke('auth-profile');
    return profileResponse.data as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>> signUp(
    String email,
    String password, {
    String? companyCode,
    String? companyName,
  }) async {
    // Edge function creates user, company, and profile atomically via admin client
    try {
      await _client.functions.invoke(
        'auth-register',
        body: {
          'email': email,
          'password': password,
          if (companyCode != null && companyCode.isNotEmpty)
            'companyCode': companyCode,
          if (companyName != null && companyName.isNotEmpty)
            'companyName': companyName,
        },
      );
    } on FunctionException catch (e) {
      throw _parseFunctionError(e);
    }

    // Establish local session after server-side user creation
    final sessionResponse = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (sessionResponse.user == null) throw Exception('Erro ao iniciar sessão');

    // Profile data is now in the session; fetch full profile
    final profileResponse = await _client.functions.invoke('auth-profile');
    final profile = profileResponse.data as Map<String, dynamic>? ?? {};

    return {
      'id': sessionResponse.user!.id,
      'email': sessionResponse.user!.email ?? email,
      'company_code': profile['company_code'],
      'is_admin': profile['is_admin'] ?? false,
    };
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_auth.currentUser == null) return null;
    try {
      final response = await _client.functions.invoke('auth-profile');
      return response.data as Map<String, dynamic>?;
    } on FunctionException {
      return null;
    }
  }

  Exception _parseFunctionError(FunctionException e) {
    final details = e.details;
    if (details is Map<String, dynamic>) {
      final msg = details['error'];
      if (msg is String) return Exception(msg);
    }
    return Exception(e.reasonPhrase ?? 'Erro desconhecido');
  }
}
