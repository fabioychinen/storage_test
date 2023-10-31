class Product {
  late int? id;
  final String name;
  late int? quantity;
  late int? barcode;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.barcode,
  });

  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    int? barcode,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
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
}
