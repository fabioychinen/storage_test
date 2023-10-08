import 'package:flutter/material.dart';
import 'package:storage_test/screens/barcode_screen.dart';
import 'package:storage_test/screens/home_screen.dart';
import 'package:storage_test/screens/new_product_screen.dart';
import 'package:storage_test/screens/product_detail_screen.dart';
import 'package:storage_test/screens/product_list_screen.dart';
import 'package:storage_test/utils/app_routes.dart';

void main() {
  runApp(const WarehouseApp());
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var product;
    return MaterialApp(
      title: 'Estoque',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomeScreen(),
      routes: {
        AppRoutes.homeScreen: (ctx) => const HomeScreen(),
        AppRoutes.newProductScreen: (ctx) => const NewProductScreen(),
        AppRoutes.barcodeScreen: (ctx) => const BarCodeScreen(),
        AppRoutes.productDetailScreen: (ctx) =>
            ProductDetailPage(product: product),
        AppRoutes.productListScreen: (ctx) => const ProductListScreen(
              productList: [],
            ),
      },
    );
  }
}
