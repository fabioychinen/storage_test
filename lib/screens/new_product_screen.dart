import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/blocs/product_bloc.dart';
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
      id: null,
      name: productController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      barcode: int.tryParse(barcodeController.text) ?? 0,
    );
    final id = await database.insert('products', product.toMap());
    productBloc.add(AddProductEvent(productController.text,
        product: product.copyWith(id: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estoque',
          style: TextStyle(
            fontFamily: 'RussoOne',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(10, 10, 10, 1),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: productController,
                decoration: const InputDecoration(
                  hintText: 'Nome do produto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                  hintText: 'Quantidade',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: barcodeController,
                decoration: const InputDecoration(
                  hintText: 'Digite o código de barras',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => addProduct(context),
              child: const Text(
                'Adicionar produto',
                style: TextStyle(
                  fontFamily: 'RussoOne',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(10, 10, 10, 1),
                ),
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
                'Código de barras',
                style: TextStyle(
                  fontFamily: 'RussoOne',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(10, 10, 10, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
