import 'package:storage_test/domain/entities/product.dart';

abstract class ProductEvent {}

class LoadProductEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Product product;

  AddProductEvent(this.product);
}

class CollectProductEvent extends ProductEvent {
  final int productId;
  final int quantity;

  CollectProductEvent({required this.productId, required this.quantity});
}

class UpdateStockEvent extends ProductEvent {
  final int productId;
  final int quantity;

  UpdateStockEvent({required this.productId, required this.quantity});
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  DeleteProductEvent({required this.productId});
}