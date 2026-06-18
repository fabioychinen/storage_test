import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSupabaseDataSource {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> queryProducts() async {
    final result = await _client.from('products').select();
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> insertProduct(
      Map<String, dynamic> values) async {
    final result =
        await _client.from('products').insert(values).select().single();
    return result;
  }

  Future<void> deleteProduct(int id) async {
    await _client.from('products').delete().eq('id', id);
  }
}
