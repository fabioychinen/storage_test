import 'package:storage_test/domain/entities/product.dart';

abstract class ProductState {
  List<Product> products;

  ProductState({required this.products});
}

class ProductInitialState extends ProductState {
  ProductInitialState() : super(products: []);
}

class ProductSuccessState extends ProductState {
  ProductSuccessState({required List<Product> products})
      : super(products: products);
}

class ProductErrorState extends ProductState {
  final String message;

  ProductErrorState({required this.message}) : super(products: []);
}