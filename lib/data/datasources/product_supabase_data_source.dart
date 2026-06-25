import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSupabaseDataSource {
  SupabaseClient get _client => Supabase.instance.client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  String? get _userEmail => _client.auth.currentUser?.email;

  Future<String> _getCompanyId() async {
    final profile = await _client
        .from('profiles')
        .select('company_id')
        .eq('id', _userId)
        .single();
    return profile['company_id'] as String;
  }

  Future<List<Map<String, dynamic>>> queryProducts() async {
    final companyId = await _getCompanyId();
    final result = await _client
        .from('products')
        .select()
        .eq('company_id', companyId)
        .isFilter('removed_at', null)
        .order('name');
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> insertProduct(
      Map<String, dynamic> values) async {
    final companyId = await _getCompanyId();
    final result = await _client
        .from('products')
        .insert({
          ...values,
          'company_id': companyId,
          'added_by': _userId,
          'added_by_email': _userEmail,
        })
        .select()
        .single();
    return result;
  }

  Future<void> increaseProductQuantity(int id, int amount) async {
    final companyId = await _getCompanyId();
    final result = await _client
        .from('products')
        .select('quantity')
        .eq('id', id)
        .eq('company_id', companyId)
        .single();
    final current = result['quantity'] as int? ?? 0;
    final updated = await _client
        .from('products')
        .update({
          'quantity': current + amount,
          'last_updated_by_email': _userEmail,
          'last_updated_at': DateTime.now().toUtc().toIso8601String(),
          'last_update_type': 'add',
        })
        .eq('id', id)
        .eq('company_id', companyId)
        .select();
    if (updated.isEmpty) throw Exception('Falha ao atualizar estoque');
  }

  Future<void> deleteProduct(int id) async {
    await _client.from('products').delete().eq('id', id);
  }

  Future<void> collectProduct(int id, int amount) async {
    final companyId = await _getCompanyId();
    final result = await _client
        .from('products')
        .select('quantity')
        .eq('id', id)
        .eq('company_id', companyId)
        .single();
    final current = result['quantity'] as int? ?? 0;
    if (amount > current) throw Exception('Quantidade insuficiente em estoque');
    final updated = await _client
        .from('products')
        .update({
          'quantity': current - amount,
          'last_updated_by_email': _userEmail,
          'last_updated_at': DateTime.now().toUtc().toIso8601String(),
          'last_update_type': 'collect',
        })
        .eq('id', id)
        .eq('company_id', companyId)
        .select();
    if (updated.isEmpty) throw Exception('Falha ao coletar produto');
  }
}