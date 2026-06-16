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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          CoreStrings.stock,
          style: CoreFonts.title,
        ),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: productController,
              decoration: const InputDecoration(
                hintText: CoreStrings.productName,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: quantityController,
              decoration: const InputDecoration(
                hintText: CoreStrings.quantity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: barcodeController,
              decoration: const InputDecoration(
                hintText: CoreStrings.enterBarcode,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => addProduct(context),
            child: const Text(
              CoreStrings.addProduct,
              style: CoreFonts.body,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarCodeScreen(),
                ),
              );
            },
            child: const Text(
              CoreStrings.barcode,
              style: CoreFonts.body,
            ),
          ),
        ]),
      ),
    );
  }
}
