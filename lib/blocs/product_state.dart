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
  ProductSuccessState(
      {required List<Product> products, required List<Product> product})
      : super(product: products);

  ProductSuccessState.single(Product product, {required products})
      : super(product: [product]);
}
