import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/models/product.dart';

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
        title: const Text(
          CoreStrings.productDetails,
          style: CoreFonts.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CoreStrings.nameOf(product.name),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(CoreStrings.quantityOf(product.quantity)),
            const SizedBox(height: 10),
            Text(CoreStrings.barcodeOf(product.barcode)),
          ],
        ),
      ),
    );
  }
}
