import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSupabaseDataSource {
  SupabaseClient get _client => Supabase.instance.client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<String> _getCompanyId() async {
    final profile = await _client
        .from('profiles')
        .select('company_id')
        .eq('id', _userId)
        .single();
    return profile['company_id'] as String;
  }

  Future<List<Map<String, dynamic>>> queryProducts() async {
    // RLS garante que só retorna produtos da empresa do usuário
    final result = await _client
        .from('products')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> insertProduct(
      Map<String, dynamic> values) async {
    final companyId = await _getCompanyId();
    final result = await _client
        .from('products')
        .insert({...values, 'company_id': companyId})
        .select()
        .single();
    return result;
  }

  Future<void> deleteProduct(int id) async {
    await _client.from('products').delete().eq('id', id);
  }
}
