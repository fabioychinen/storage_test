import 'package:storage_test/domain/repositories/product_repository.dart';

class CollectProduct {
  final ProductRepository repository;

  CollectProduct(this.repository);

  Future<void> call(int productId, int amount) => repository.collectProduct(productId, amount);
}