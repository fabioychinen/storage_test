import 'package:storage_test/models/product.dart';

abstract class ProductState {
  List<Product> products;

  ProductState({
    required this.products,
  });
}

class ProductInitialState extends ProductState {
  ProductInitialState() : super(products: []);
}

class ProductSuccessState extends ProductState {
  ProductSuccessState({required List<Product> products})
      : super(products: products);

  ProductSuccessState.single(Product product) : super(products: [product]);
}
