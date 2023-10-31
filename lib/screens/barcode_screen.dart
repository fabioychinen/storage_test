import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:storage_test/blocs/barcode_bloc.dart';

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({Key? key}) : super(key: key);

  @override
  State<BarCodeScreen> createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeBloc(),
      child: const BarcodeScreenContents(),
    );
  }
}

class BarcodeScreenContents extends StatelessWidget {
  const BarcodeScreenContents({super.key});

  void readBARCode(BuildContext context) async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.BARCODE,
    );

    // ignore: use_build_context_synchronously
    BlocProvider.of<BarcodeBloc>(context)
        .add(UpdateBarcodeEvent(code != '-1' ? code : 'Inválido'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<BarcodeBloc, String>(
              builder: (context, barcode) {
                return const Divider();
              },
            ),
            ElevatedButton.icon(
              onPressed: () => readBARCode(context),
              icon: Image.asset('assets/images/barcode.png'),
              label: const Text(
                'Escanear',
                style: TextStyle(
                    fontFamily: 'RussoOne',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(10, 10, 10, 1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
