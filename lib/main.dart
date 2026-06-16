import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/data/datasources/product_local_data_source.dart';
import 'package:storage_test/data/repositories/product_repository_impl.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/remove_product.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/barcode/barcode_screen.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';
import 'package:storage_test/presentation/screens/new_product/new_product_screen.dart';
import 'package:storage_test/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:storage_test/presentation/screens/product_list/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productLocalDataSource = ProductLocalDataSource();
  final productRepository = ProductRepositoryImpl(productLocalDataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(
            loadProducts: LoadProducts(productRepository),
            addProduct: AddProduct(productRepository),
            removeProduct: RemoveProduct(productRepository),
          ),
        ),
        BlocProvider(
          create: (context) => BarcodeBloc(),
        ),
      ],
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
        AppRoutes.productListScreen: (ctx) => const ProductListScreen(),
        AppRoutes.productDetailScreen: (ctx) {
          final product = ModalRoute.of(ctx)!.settings.arguments as Product;
          return ProductDetailScreen(product: product);
        }
      },
    );
  }
}
