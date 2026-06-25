import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';

class BarCodeScreen extends StatelessWidget {
  const BarCodeScreen({super.key});

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    context.read<BarcodeBloc>().add(UpdateBarcodeEvent(code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.barcode,
          style: CoreFonts.title,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) => _onDetect(context, capture),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<BarcodeBloc, String>(
              builder: (context, barcode) {
                return Text(
                  CoreStrings.barcodeOf(barcode),
                  style: CoreFonts.body,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}