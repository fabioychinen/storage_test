import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/blocs/product_bloc.dart';
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

  get product => null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp(
        title: 'Estoque',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const HomeScreen(),
        routes: {
          AppRoutes.homeScreen: (ctx) => const HomeScreen(),
          AppRoutes.newProductScreen: (ctx) => const NewProductScreen(),
          AppRoutes.barcodeScreen: (ctx) => const BarCodeScreen(),
          AppRoutes.productListScreen: (ctx) =>
              const ProductListScreen(productList: []),
          AppRoutes.productDetailScreen: (ctx) =>
              ProductDetailScreen(product: product),
        },
      ),
    );
  }
}
