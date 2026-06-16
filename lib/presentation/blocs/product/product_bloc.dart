import 'package:bloc/bloc.dart';
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
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      },
    );

    on<AddProductEvent>(
      (event, emit) async {
        await _addProduct(event.product);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      },
    );

    on<RemoveProductEvent>(
      (event, emit) async {
        await _removeProduct(event.productId);
        final products = await _loadProducts();
        emit(ProductSuccessState(products: products));
      },
    );
  }
}
