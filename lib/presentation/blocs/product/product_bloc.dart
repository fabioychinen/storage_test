import 'package:bloc/bloc.dart';
import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/remove_product.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LoadProducts _loadProducts;
  final AddProduct _addProduct;
  final RemoveProduct _removeProduct;

  ProductBloc({
    required LoadProducts loadProducts,
    required AddProduct addProduct,
    required RemoveProduct removeProduct,
  })  : _loadProducts = loadProducts,
        _addProduct = addProduct,
        _removeProduct = removeProduct,
        super(ProductInitialState()) {
    on<LoadProductEvent>(
      (event, emit) async {
        appLogger.i('LoadProductEvent recebido');
        try {
          final products = await _loadProducts();
          emit(ProductSuccessState(products: products));
        } catch (e) {
          appLogger.e('Erro ao carregar produtos', error: e);
          emit(ProductErrorState(message: e.toString()));
        }
      },
    );

    on<AddProductEvent>(
      (event, emit) async {
        appLogger.i('AddProductEvent recebido: ${event.product.name}');
        try {
          await _addProduct(event.product);
          final products = await _loadProducts();
          emit(ProductSuccessState(products: products));
        } catch (e) {
          appLogger.e('Erro ao adicionar produto', error: e);
          emit(ProductErrorState(message: e.toString()));
        }
      },
    );

    on<RemoveProductEvent>(
      (event, emit) async {
        appLogger.i('RemoveProductEvent recebido: id=${event.productId}');
        try {
          await _removeProduct(event.productId);
          final products = await _loadProducts();
          emit(ProductSuccessState(products: products));
        } catch (e) {
          appLogger.e('Erro ao remover produto', error: e);
          emit(ProductErrorState(message: e.toString()));
        }
      },
    );
  }
}
