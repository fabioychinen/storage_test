import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/blocs/product_bloc.dart';
import 'package:storage_test/models/product.dart';
import 'package:storage_test/repositories/product_repository.dart';
import 'package:storage_test/screens/barcode_screen.dart';
import 'package:storage_test/screens/home_screen.dart';
import 'package:storage_test/screens/new_product_screen.dart';
import 'package:storage_test/screens/product_detail_screen.dart';
import 'package:storage_test/screens/product_list_screen.dart';
import 'package:storage_test/utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productRepository = ProductRepository();
  productRepository.initDatabase('storage.db');

  runApp(
    BlocProvider(
      create: (context) => ProductBloc(productRepository: productRepository),
      child: const WarehouseApp(),
    ),
  );
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        AppRoutes.productListScreen: (ctx) =>
            const ProductListScreen(productList: []),
        AppRoutes.productDetailScreen: (ctx) {
          final product = ModalRoute.of(ctx)!.settings.arguments as Product;
          return ProductDetailScreen(product: product);
        }
      },
    );
  }
}
