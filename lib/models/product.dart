class Product {
  int? id;
  final String name;
  int? quantity;
  int? barcode;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.barcode,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int?,
      barcode: map['barcode'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
    };
  }

  Product copyWith({
    required int id,
    String? name,
    int? quantity,
    int? barcode,
  }) {
    return Product(
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
        id: id);
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
    };
  }
}
