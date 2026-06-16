import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/blocs/product_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/data/product_db.dart';
import 'package:storage_test/screens/barcode_screen.dart';
import 'package:storage_test/models/product.dart';
import 'package:storage_test/blocs/product_events.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  TextEditingController productController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

  void addProduct(BuildContext context) async {
    final productBloc = BlocProvider.of<ProductBloc>(context);
    final productDb = ProductDB.instance;
    final database = await productDb.database;
    final product = Product(
      name: productController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      barcode: int.tryParse(barcodeController.text) ?? 0,
      id: 0,
    );

    final id = await database.insert('products', product.toMapWithoutId());

    final productWithId = product.copyWith(id: id);
    productBloc.add(AddProductEvent(productWithId));
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
