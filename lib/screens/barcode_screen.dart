import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({Key? key}) : super(key: key);

  @override
  State<BarCodeScreen> createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> {
  String barcode = '';
  List<String> bardoces = [];

  readBARCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.BARCODE,
    );
    setState(() => barcode = code != '-1' ? code : 'Invalid');
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
            if (barcode != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Barcode: $barcode',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ElevatedButton.icon(
              onPressed: readBARCode,
              icon: const Icon(Icons.barcode_reader),
              label: const Text('Scan now'),
            ),
          ],
        ),
      ),
    );
  }
}
