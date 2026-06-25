import 'package:storage_test/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    super.id,
    required super.name,
    required super.quantity,
    required super.barcode,
    super.addedByEmail,
    super.removedByEmail,
    super.removedAt,
    super.lastUpdatedByEmail,
    super.lastUpdatedAt,
    super.lastUpdateType,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int?,
      barcode: map['barcode'] as int?,
      addedByEmail: map['added_by_email'] as String?,
      removedByEmail: map['removed_by_email'] as String?,
      removedAt: map['removed_at'] != null
          ? DateTime.parse(map['removed_at'] as String)
          : null,
      lastUpdatedByEmail: map['last_updated_by_email'] as String?,
      lastUpdatedAt: map['last_updated_at'] != null
          ? DateTime.parse(map['last_updated_at'] as String)
          : null,
      lastUpdateType: map['last_update_type'] as String?,
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