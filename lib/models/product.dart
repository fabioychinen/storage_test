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
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      barcode: map['barcode'],
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
    int? id,
    String? name,
    int? quantity,
    int? barcode,
  }) {
    return Product(
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
        id: id ?? this.id);
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'quantity': quantity,
      'barcode': barcode,
    };
  }
}
