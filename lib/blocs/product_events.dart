import 'package:storage_test/models/product.dart';

abstract class ProductEvent {}

class LoadProductEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Product product;

  AddProductEvent(this.product);
}

class RemoveProductEvent extends ProductEvent {
  final int productId;

  RemoveProductEvent({
    required this.productId,
  });
}
