import 'package:storage_test/domain/repositories/product_repository.dart';

class IncreaseProductQuantity {
  final ProductRepository repository;

  IncreaseProductQuantity(this.repository);

  Future<void> call(int productId, int amount) => repository.increaseProductQuantity(productId, amount);
}