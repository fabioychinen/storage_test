import 'package:storage_test/data/datasources/product_local_data_source.dart';
import 'package:storage_test/data/models/product_model.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> loadProducts() async {
    final maps = await dataSource.queryProducts();
    return maps.map(ProductModel.fromMap).toList();
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = ProductModel(
      name: product.name,
      quantity: product.quantity,
      barcode: product.barcode,
    );
    final id = await dataSource.insertProduct(model.toMapWithoutId());
    return ProductModel(
      id: id,
      name: model.name,
      quantity: model.quantity,
      barcode: model.barcode,
    );
  }

  @override
  Future<void> removeProduct(int id) {
    return dataSource.deleteProduct(id);
  }
}
