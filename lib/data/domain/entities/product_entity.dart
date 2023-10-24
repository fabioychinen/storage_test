import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductEntity extends Equatable {
  late int? productID;
  final String name;
  late int? quantity;
  late int? barcode;

  ProductEntity(
      {this.productID,
      required this.name,
      required this.quantity,
      required this.barcode});

  @override
  List<Object?> get props => [productID];
}
