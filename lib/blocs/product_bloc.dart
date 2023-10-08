import 'package:bloc/bloc.dart';
import 'package:storage_test/blocs/product_events.dart';
import 'package:storage_test/blocs/product_state.dart';
import 'package:storage_test/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final _productRepo = ProductRepository();

  // final StreamController<ProductEvent> _inputProductController = StreamController<ProductEvent>();
  // final StreamController<ProductState> _outputProductController = StreamController<ProductState>();

  // Sink<ProductEvent> get inputProduct => _inputProductController.sink;
  // Stream<ProductState> get stream => _outputProductController.stream;

  ProductBloc() : super(ProductInitialState()) {
    // _inputClientController.stream.listen(_mapEventToState);
    on<LoadProductEvent>(
      (event, emit) =>
          emit(ProductSuccessState(products: _productRepo.loadProduct())),
    );

    on<AddProductEvent>(
      (event, emit) => emit(ProductSuccessState(
          products: _productRepo.addProduct(event.product))),
    );

    on<RemoveProductEvent>(
      (event, emit) => emit(ProductSuccessState(
          products: _productRepo.removeProduct(event.product))),
    );
  }

  // _mapEventToState(ProductEvent event) {
  //   List<Product> products = [];
  //   if (event is LoadProductEvent) {
  //     products = _productRepo.loadProducts();
  //   } else if (event is AddProductEvent) {
  //     products = _productRepo.addProduct(event.product);
  //   } else if (event is RemoveProductEvent) {
  //     products = _productRepo.removeProduct(event.product);
  //   }
  //   _outputClientController.add(ClientSuccessState(clients: clients));
  // }
}
