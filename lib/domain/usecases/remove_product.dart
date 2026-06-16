import 'package:storage_test/domain/repositories/product_repository.dart';

class RemoveProduct {
  final ProductRepository repository;

  RemoveProduct(this.repository);

  Future<void> call(int productId) => repository.removeProduct(productId);
}
