import 'package:bloc/bloc.dart';
import 'package:storage_test/blocs/product_events.dart';
import 'package:storage_test/blocs/product_state.dart';
import 'package:storage_test/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final _productRepo = ProductRepository(databasePath: 'storage.db');

  ProductBloc({required ProductRepository productRepository})
      : super(ProductInitialState()) {
    on<LoadProductEvent>(
      (event, emit) async {
        final products = await _productRepo.loadProducts();
        emit(ProductSuccessState(products: products));
      },
    );

    on<AddProductEvent>(
      (event, emit) async {
        final addedProduct = await _productRepo.addProduct(event.product);
        emit(ProductSuccessState.single(addedProduct));
      },
    );

    on<RemoveProductEvent>(
      (event, emit) async {
        await _productRepo.removeProduct(event.productId);
        final products = await _productRepo.loadProducts();
        emit(ProductSuccessState(products: products));
      },
    );
  }
}
