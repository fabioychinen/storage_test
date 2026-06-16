import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Product> call(Product product) => repository.addProduct(product);
}
