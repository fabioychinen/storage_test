import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:storage_test/app/warehouse_app.dart';
import 'package:storage_test/core/supabase_config.dart';
import 'package:storage_test/data/datasources/auth_supabase_data_source.dart';
import 'package:storage_test/data/datasources/product_supabase_data_source.dart';
import 'package:storage_test/data/repositories/auth_repository_impl.dart';
import 'package:storage_test/data/repositories/product_repository_impl.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/delete_product.dart';
import 'package:storage_test/domain/usecases/get_logged_user.dart';
import 'package:storage_test/domain/usecases/increase_product_quantity.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/login.dart';
import 'package:storage_test/domain/usecases/logout.dart';
import 'package:storage_test/domain/usecases/register.dart';
import 'package:storage_test/domain/usecases/remove_product.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';

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
            collectProduct: CollectProduct(productRepository),
            increaseProductQuantity: IncreaseProductQuantity(productRepository),
            deleteProduct: DeleteProduct(productRepository),
          ),
        ),
        BlocProvider(create: (context) => BarcodeBloc()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const WarehouseApp(),
    ),
  );
}