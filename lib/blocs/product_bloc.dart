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
    // _inputProductController.stream.listen(_mapEventToState);
    on<LoadProductEvent>(
      (event, emit) =>
          emit(ProductSuccessState(product: _productRepo.loadProduct())),
    );

    on<AddProductEvent>(
      (event, emit) => emit(
          ProductSuccessState(product: _productRepo.addProduct(event.product))),
    );

    on<RemoveProductEvent>(
      (event, emit) => emit(ProductSuccessState(
          product: _productRepo.removeProduct(event.product))),
    );
  }

  // _mapEventToState(ProductEvent event) {
  //   List<Product> product = [];
  //   if (event is LoadProductEvent) {
  //     product = _productRepo.loadProduct();
  //   } else if (event is AddProductEvent) {
  //     product = _productRepo.addProduct(event.product);
  //   } else if (event is RemoveProductEvent) {
  //     product = _productRepo.removeProduct(event.product);
  //   }
  //   _outputProductController.add(ProductSuccessState(product: product));
  // }
}
