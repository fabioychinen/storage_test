import 'package:flutter/material.dart';
import 'package:storage_test/screens/barcode_screen.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  List<String> products = [];
  TextEditingController productController = TextEditingController();

  void addProduct() {
    setState(() {
      String productName = productController.text;

      if (productName.isNotEmpty) {
        products.add(productName);
        productController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Warehouse App',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: productController,
              decoration: const InputDecoration(
                hintText: 'Enter product name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: addProduct,
            child: const Text('Add Product'),
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
              child: const Text('Scan barcode here')),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
