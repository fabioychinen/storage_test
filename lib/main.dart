import 'package:flutter/material.dart';
//import 'package:storage_test/screens/barcode_screen.dart';
import 'package:storage_test/screens/warehouse_screen.dart';

void main() {
  runApp(const WarehouseApp());
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const WarehouseScreen(),
    );
  }
}
