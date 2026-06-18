import 'package:bloc/bloc.dart';
import 'package:storage_test/core/app_logger.dart';

abstract class BarcodeEvent {}

class UpdateBarcodeEvent extends BarcodeEvent {
  final String barcode;

  UpdateBarcodeEvent(this.barcode);
}

class BarcodeBloc extends Bloc<BarcodeEvent, String> {
  BarcodeBloc() : super('') {
    on<UpdateBarcodeEvent>((event, emit) {
      appLogger.i('UpdateBarcodeEvent recebido: ${event.barcode}');
      emit(event.barcode);
    });
  }
}
