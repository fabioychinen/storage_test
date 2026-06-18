import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/data/datasources/product_supabase_data_source.dart';
import 'package:storage_test/data/models/product_model.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductSupabaseDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> loadProducts() async {
    try {
      final maps = await dataSource.queryProducts();
      final products = maps.map(ProductModel.fromMap).toList();
      appLogger.d('Carregados ${products.length} produtos do Supabase');
      return products;
    } catch (error, stackTrace) {
      appLogger.e('Erro ao carregar produtos', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final model = ProductModel(
        name: product.name,
        quantity: product.quantity,
        barcode: product.barcode,
      );
      final inserted = await dataSource.insertProduct(model.toMapWithoutId());
      final added = ProductModel.fromMap(inserted);
      appLogger.d('Produto adicionado no Supabase: ${added.name} (id=${added.id})');
      return added;
    } catch (error, stackTrace) {
      appLogger.e(
        'Erro ao adicionar produto "${product.name}"',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> removeProduct(int id) async {
    try {
      await dataSource.deleteProduct(id);
      appLogger.d('Produto removido do Supabase: id=$id');
    } catch (error, stackTrace) {
      appLogger.e(
        'Erro ao remover produto id=$id',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
