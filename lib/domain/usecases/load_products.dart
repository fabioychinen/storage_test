import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';

class LoadProducts {
  final ProductRepository repository;

  LoadProducts(this.repository);

  Future<List<Product>> call() => repository.loadProducts();
}
