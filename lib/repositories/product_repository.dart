import '../models/product.dart';

class ProductRepository {
  final List<Product> _product = [];

  List<Product> loadProduct() {
    _product.addAll([
      Product(
        id: null,
        name: 'Laranja',
        quantity: null,
        barcode: null,
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
