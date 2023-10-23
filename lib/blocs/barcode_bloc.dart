import 'package:bloc/bloc.dart';
import 'package:storage_test/blocs/product_events.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, String> {
  BarcodeBloc() : super('');

  Stream<String> mapEventToState(BarcodeEvent event) async* {
    if (event is UpdateBarcodeEvent) {
      yield event.barcode;
    }
  }
}

abstract class BarcodeEvent {}

class UpdateBarcodeEvent extends BarcodeEvent {
  final String barcode;

  UpdateBarcodeEvent(this.barcode);
}

class AddProductWithBarcodeEvent extends ProductEvent {
  final String barcode;
  AddProductWithBarcodeEvent(this.barcode);
}
