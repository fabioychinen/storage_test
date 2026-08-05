import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/delete_product.dart';
import 'package:storage_test/domain/usecases/get_logged_user.dart';
import 'package:storage_test/domain/usecases/increase_product_quantity.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/login.dart';
import 'package:storage_test/domain/usecases/logout.dart';
import 'package:storage_test/domain/usecases/register.dart';
import 'package:storage_test/domain/usecases/remove_product.dart' show CollectProduct;
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/delete_product/delete_product_screen.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';
import 'package:storage_test/presentation/screens/new_product/new_product_screen.dart';
import 'package:storage_test/presentation/screens/product_list/product_list_screen.dart';
import 'package:storage_test/presentation/screens/remove_product/remove_product_screen.dart';
import 'package:storage_test/presentation/screens/settings/settings_screen.dart';
import 'package:storage_test/presentation/screens/update_stock/update_stock_screen.dart';
import 'fake_repositories.dart';

final kTestUser = User(
  id: 'test-uid',
  email: 'dev@empresa.com',
  companyCode: 'ABCD1234',
  isAdmin: true,
);

const kGoldenSize = Size(390, 844);

void setGoldenDevice(WidgetTester tester) {
  tester.view.physicalSize = kGoldenSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget buildTestApp({
  required Widget home,
  ThemeMode themeMode = ThemeMode.light,
  List<Product> products = const [],
  User? user,
}) {
  final resolvedUser = user ?? kTestUser;
  final productRepo = FakeProductRepository(initial: products);
  final authRepo = FakeAuthRepository(user: resolvedUser);

  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          login: Login(authRepo),
          register: Register(authRepo),
          logout: Logout(authRepo),
          getLoggedUser: GetLoggedUser(authRepo),
        ),
      ),
      BlocProvider(
        create: (_) => ProductBloc(
          loadProducts: LoadProducts(productRepo),
          addProduct: AddProduct(productRepo),
          collectProduct: CollectProduct(productRepo),
          increaseProductQuantity: IncreaseProductQuantity(productRepo),
          deleteProduct: DeleteProduct(productRepo),
        ),
      ),
      BlocProvider(create: (_) => BarcodeBloc()),
      BlocProvider(create: (_) {
        final cubit = ThemeCubit();
        if (themeMode == ThemeMode.dark) cubit.toggleTheme(true);
        return cubit;
      }),
    ],
    child: MaterialApp(
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
      home: home,
      routes: {
        AppRoutes.homeScreen: (_) => const HomeScreen(),
        AppRoutes.newProductScreen: (_) => const NewProductScreen(),
        AppRoutes.productListScreen: (_) => const ProductListScreen(),
        AppRoutes.collectProductScreen: (_) => const CollectProductScreen(),
        AppRoutes.removeProductScreen: (_) => const DeleteProductScreen(),
        AppRoutes.updateStockScreen: (_) => const UpdateStockScreen(),
        AppRoutes.settingsScreen: (_) => const SettingsScreen(),
      },
    ),
  );
}