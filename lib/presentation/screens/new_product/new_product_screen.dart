import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/screens/barcode/barcode_screen.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final productController = TextEditingController();
  final quantityController = TextEditingController();
  final barcodeController = TextEditingController();

  void addProduct(BuildContext context) {
    final product = Product(
      name: productController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      barcode: int.tryParse(barcodeController.text) ?? 0,
    );

    context.read<ProductBloc>().add(AddProductEvent(product));
  }

  InputDecoration _decorationFor(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.stock,
          style: CoreFonts.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productController,
              decoration: _decorationFor(
                CoreStrings.productName,
                Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              controller: quantityController,
              decoration: _decorationFor(
                CoreStrings.quantity,
                Icons.numbers_outlined,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              controller: barcodeController,
              decoration: _decorationFor(
                CoreStrings.enterBarcode,
                Icons.qr_code_2_outlined,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => addProduct(context),
                icon: const Icon(Icons.add),
                label: const Text(
                  CoreStrings.addProduct,
                  style: CoreFonts.body,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarCodeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_outlined),
                label: const Text(
                  CoreStrings.barcode,
                  style: CoreFonts.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
