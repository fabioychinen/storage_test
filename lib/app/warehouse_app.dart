import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/barcode/barcode_screen.dart';
import 'package:storage_test/presentation/screens/delete_product/delete_product_screen.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';
import 'package:storage_test/presentation/screens/login/login_screen.dart';
import 'package:storage_test/presentation/screens/new_product/new_product_screen.dart';
import 'package:storage_test/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:storage_test/presentation/screens/product_list/product_list_screen.dart';
import 'package:storage_test/presentation/screens/remove_product/remove_product_screen.dart';
import 'package:storage_test/presentation/screens/settings/settings_screen.dart';
import 'package:storage_test/presentation/screens/splash/splash_screen.dart';
import 'package:storage_test/presentation/screens/update_stock/update_stock_screen.dart';

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) => MaterialApp(
        title: 'Estoque',
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            brightness: Brightness.dark,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final Widget screen;
            if (state is AuthAuthenticatedState) {
              screen = const HomeScreen();
            } else if (state is AuthInitialState || state is AuthLoadingState) {
              screen = const SplashScreen();
            } else {
              screen = const LoginScreen();
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: KeyedSubtree(
                key: ValueKey(screen.runtimeType),
                child: screen,
              ),
            );
          },
        ),
        routes: {
          AppRoutes.loginScreen: (ctx) => const LoginScreen(),
          AppRoutes.homeScreen: (ctx) => const HomeScreen(),
          AppRoutes.newProductScreen: (ctx) => const NewProductScreen(),
          AppRoutes.barcodeScreen: (ctx) => const BarCodeScreen(),
          AppRoutes.productListScreen: (ctx) => const ProductListScreen(),
          AppRoutes.productDetailScreen: (ctx) {
            final product = ModalRoute.of(ctx)!.settings.arguments as Product;
            return ProductDetailScreen(product: product);
          },
          AppRoutes.collectProductScreen: (ctx) => const CollectProductScreen(),
          AppRoutes.removeProductScreen: (ctx) => const DeleteProductScreen(),
          AppRoutes.updateStockScreen: (ctx) => const UpdateStockScreen(),
          AppRoutes.settingsScreen: (ctx) => const SettingsScreen(),
        },
      ),
    );
  }
}