import 'package:storage_test/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> loadProducts();
  Future<Product> addProduct(Product product);
  Future<void> increaseProductQuantity(int id, int amount);
  Future<void> collectProduct(int id, int amount);
  Future<void> deleteProduct(int id);
}