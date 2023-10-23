import 'package:storage_test/models/product.dart';

abstract class ProductState {
  List<Product> product;

  ProductState({
    required this.product,
  });
}

class ProductInitialState extends ProductState {
  ProductInitialState() : super(product: []);
}

class ProductSuccessState extends ProductState {
  ProductSuccessState({required List<Product> product})
      : super(product: product);
}
