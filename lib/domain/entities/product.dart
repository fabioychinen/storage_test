class Product {
  final int? id;
  final String name;
  final int? quantity;
  final int? barcode;
  final String? addedByEmail;
  final String? removedByEmail;
  final DateTime? removedAt;
  final String? lastUpdatedByEmail;
  final DateTime? lastUpdatedAt;
  final String? lastUpdateType; // 'add' or 'collect'

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.barcode,
    this.addedByEmail,
    this.removedByEmail,
    this.removedAt,
    this.lastUpdatedByEmail,
    this.lastUpdatedAt,
    this.lastUpdateType,
  });

  Product copyWith({
    required int id,
    String? name,
    int? quantity,
    int? barcode,
    String? addedByEmail,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
      addedByEmail: addedByEmail ?? this.addedByEmail,
    );
  }
}