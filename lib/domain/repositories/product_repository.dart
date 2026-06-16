import 'package:storage_test/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> loadProducts();

  Future<Product> addProduct(Product product);

  Future<void> removeProduct(int id);
}
