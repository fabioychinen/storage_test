import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:storage_test/core/supabase_config.dart';
import 'package:storage_test/data/datasources/auth_supabase_data_source.dart';
import 'package:storage_test/data/datasources/product_supabase_data_source.dart';
import 'package:storage_test/data/repositories/auth_repository_impl.dart';
import 'package:storage_test/data/repositories/product_repository_impl.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/get_logged_user.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/login.dart';
import 'package:storage_test/domain/usecases/logout.dart';
import 'package:storage_test/domain/usecases/register.dart';
import 'package:storage_test/domain/usecases/remove_product.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/barcode/barcode_screen.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';
import 'package:storage_test/presentation/screens/login/login_screen.dart';
import 'package:storage_test/presentation/screens/new_product/new_product_screen.dart';
import 'package:storage_test/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:storage_test/presentation/screens/product_list/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  final authDataSource = AuthSupabaseDataSource();
  final authRepository = AuthRepositoryImpl(authDataSource);

  final productDataSource = ProductSupabaseDataSource();
  final productRepository = ProductRepositoryImpl(productDataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            login: Login(authRepository),
            register: Register(authRepository),
            logout: Logout(authRepository),
            getLoggedUser: GetLoggedUser(authRepository),
          ),
        ),
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
        BlocProvider(
          create: (context) => ThemeCubit(),
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
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) => MaterialApp(
      title: 'Estoque',
      themeMode: themeMode,
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
          if (state is AuthAuthenticatedState) return const HomeScreen();
          if (state is AuthInitialState || state is AuthLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const LoginScreen();
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
        }
      },
      ),
    );
  }
}
