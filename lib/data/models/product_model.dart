import 'package:storage_test/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    super.id,
    required super.name,
    required super.quantity,
    required super.barcode,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int?,
      barcode: map['barcode'] as int?,
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
    };
  }
}
