import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSupabaseDataSource {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> queryProducts() async {
    final response = await _client.functions.invoke('products-list');
    final data = response.data as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> insertProduct(
      Map<String, dynamic> values) async {
    try {
      final response = await _client.functions.invoke(
        'products-add',
        body: values,
      );
      return response.data as Map<String, dynamic>;
    } on FunctionException catch (e) {
      throw _parseFunctionError(e);
    }
  }

  Future<void> increaseProductQuantity(int id, int amount) async {
    try {
      await _client.functions.invoke(
        'products-increase',
        body: {'productId': id, 'amount': amount},
      );
    } on FunctionException catch (e) {
      throw _parseFunctionError(e);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _client.functions.invoke(
        'products-delete',
        body: {'productId': id},
      );
    } on FunctionException catch (e) {
      throw _parseFunctionError(e);
    }
  }

  Future<void> collectProduct(int id, int amount) async {
    try {
      await _client.functions.invoke(
        'products-decrease',
        body: {'productId': id, 'amount': amount},
      );
    } on FunctionException catch (e) {
      throw _parseFunctionError(e);
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
