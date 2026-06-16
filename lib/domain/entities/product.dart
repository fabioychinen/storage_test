class Product {
  final int? id;
  final String name;
  final int? quantity;
  final int? barcode;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.barcode,
  });

  Product copyWith({
    required int id,
    String? name,
    int? quantity,
    int? barcode,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
    );
  }
}
