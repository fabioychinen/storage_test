import 'package:storage_test/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> call(int productId) => repository.deleteProduct(productId);
}