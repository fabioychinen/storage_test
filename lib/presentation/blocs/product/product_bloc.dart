import 'package:bloc/bloc.dart';
import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/delete_product.dart';
import 'package:storage_test/domain/usecases/increase_product_quantity.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/remove_product.dart' show CollectProduct;
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LoadProducts _loadProducts;
  final AddProduct _addProduct;
  final CollectProduct _collectProduct;
  final IncreaseProductQuantity _increaseProductQuantity;
  final DeleteProduct _deleteProduct;

  ProductBloc({
    required LoadProducts loadProducts,
    required AddProduct addProduct,
    required CollectProduct collectProduct,
    required IncreaseProductQuantity increaseProductQuantity,
    required DeleteProduct deleteProduct,
  })  : _loadProducts = loadProducts,
        _addProduct = addProduct,
        _collectProduct = collectProduct,
        _increaseProductQuantity = increaseProductQuantity,
        _deleteProduct = deleteProduct,
        super(ProductInitialState()) {
    on<LoadProductEvent>((event, emit) async {
      appLogger.i('LoadProductEvent');
      try {
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      } catch (e) {
        appLogger.e('Erro ao carregar produtos', error: e);
        emit(ProductErrorState(message: e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      appLogger.i('AddProductEvent: ${event.product.name}');
      try {
        await _addProduct(event.product);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      } catch (e) {
        appLogger.e('Erro ao adicionar produto', error: e);
        emit(ProductErrorState(message: e.toString()));
      }
    });

    on<CollectProductEvent>((event, emit) async {
      appLogger.i('CollectProductEvent: id=${event.productId}, qty=${event.quantity}');
      try {
        await _collectProduct(event.productId, event.quantity);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      } catch (e) {
        appLogger.e('Erro ao reduzir quantidade', error: e);
        emit(ProductErrorState(message: e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      appLogger.i('DeleteProductEvent: id=${event.productId}');
      try {
        await _deleteProduct(event.productId);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      } catch (e) {
        appLogger.e('Erro ao remover produto', error: e);
        emit(ProductErrorState(message: e.toString()));
      }
    });

    on<UpdateStockEvent>((event, emit) async {
      appLogger.i('UpdateStockEvent: id=${event.productId}, qty=${event.quantity}');
      try {
        await _increaseProductQuantity(event.productId, event.quantity);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      } catch (e) {
        appLogger.e('Erro ao atualizar estoque', error: e);
        emit(ProductErrorState(message: e.toString()));
      }
    });
  }
}