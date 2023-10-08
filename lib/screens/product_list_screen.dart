import 'package:flutter/material.dart';
import 'package:storage_test/models/product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, required this.productList});
  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Produtos',
          style: TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (ctx, index) {
          final product = productList[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade: ${product.quantity}'),
                Text('Código de Barras: ${product.barcode}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
