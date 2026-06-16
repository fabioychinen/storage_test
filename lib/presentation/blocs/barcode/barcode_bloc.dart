import 'package:bloc/bloc.dart';

abstract class BarcodeEvent {}

class UpdateBarcodeEvent extends BarcodeEvent {
  final String barcode;

  UpdateBarcodeEvent(this.barcode);
}

class BarcodeBloc extends Bloc<BarcodeEvent, String> {
  BarcodeBloc() : super('') {
    on<UpdateBarcodeEvent>((event, emit) => emit(event.barcode));
  }
}
