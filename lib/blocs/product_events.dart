import 'package:storage_test/models/product.dart';

abstract class ProductEvent {}

class LoadProductEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  Product product;

  AddProductEvent({
    required this.product,
  });
}

class RemoveProductEvent extends ProductEvent {
  Product product;

  RemoveProductEvent({
    required this.product,
  });
}
