import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.productDetails,
          style: CoreFonts.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(
                  CoreStrings.nameOf(product.name),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.numbers_outlined),
                title: Text(CoreStrings.quantityOf(product.quantity)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.qr_code_2_outlined),
                title: Text(CoreStrings.barcodeOf(product.barcode)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
