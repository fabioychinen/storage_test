import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/core/core_assets.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';

class BarCodeScreen extends StatelessWidget {
  const BarCodeScreen({super.key});

  void readBARCode(BuildContext context) async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      CoreStrings.cancel,
      false,
      ScanMode.BARCODE,
    );

    // ignore: use_build_context_synchronously
    BlocProvider.of<BarcodeBloc>(context)
        .add(UpdateBarcodeEvent(code != '-1' ? code : CoreStrings.invalid));
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
                return Text(
                  CoreStrings.barcodeOf(barcode),
                  style: CoreFonts.body,
                );
              },
            ),
            const Divider(),
            ElevatedButton.icon(
              onPressed: () => readBARCode(context),
              icon: Image.asset(CoreAssets.barcode),
              label: const Text(
                CoreStrings.scan,
                style: CoreFonts.body,
              ),
            )
          ],
        ),
      ),
    );
  }
}
