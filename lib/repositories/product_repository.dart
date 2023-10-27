import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class ProductRepository extends ChangeNotifier {
  final List<Product> _product = [];

  List<Product> loadProduct() {
    _product.addAll([
      Product(
        id: 1,
        name: 'Laranja',
        quantity: 12,
        barcode: 123456789,
      )
    ]);
    return _product;
  }

  List<Product> addProduct(Product product) {
    _product.add(product);
    return _product;
  }

  List<Product> removeProduct(Product product) {
    _product.remove(product);
    return _product;
  }
}
