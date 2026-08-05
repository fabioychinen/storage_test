import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({super.key});

  @override
  State<BarCodeScreen> createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> {
  bool _detected = false;

  void _onDetect(BarcodeCapture capture) {
    if (_detected || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _detected = true);
    context.read<BarcodeBloc>().add(UpdateBarcodeEvent(code));

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(CoreStrings.barcode, style: CoreFonts.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Câmera
          MobileScanner(
            onDetect: _onDetect,
          ),

          // Overlay escurecido com viewfinder
          CustomPaint(
            painter: _ViewfinderOverlay(
              detected: _detected,
              accentColor: _detected ? Colors.green : Colors.white,
            ),
          ),

          // Instrução + resultado
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              child: BlocBuilder<BarcodeBloc, String>(
                builder: (context, barcode) {
                  if (_detected && barcode.isNotEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          barcode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Código detectado',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_scanner,
                          color: Colors.white54, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        'Aponte para o código de barras',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderOverlay extends CustomPainter {
  final bool detected;
  final Color accentColor;

  const _ViewfinderOverlay({
    required this.detected,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final viewfinderSize = size.width * 0.65;
    final viewfinderRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: viewfinderSize,
      height: viewfinderSize,
    );

    // Overlay semitransparente com buraco no viewfinder
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
          RRect.fromRectAndRadius(viewfinderRect, const Radius.circular(12)));
    canvas.drawPath(path, overlayPaint);

    // Cantos do viewfinder
    const cornerLen = 28.0;
    const strokeW = 3.5;
    final cornerPaint = Paint()
      ..color = accentColor
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final l = viewfinderRect.left;
    final t = viewfinderRect.top;
    final r = viewfinderRect.right;
    final b = viewfinderRect.bottom;

    // Canto superior-esquerdo
    canvas.drawLine(Offset(l, t + cornerLen), Offset(l, t), cornerPaint);
    canvas.drawLine(Offset(l, t), Offset(l + cornerLen, t), cornerPaint);
    // Canto superior-direito
    canvas.drawLine(Offset(r - cornerLen, t), Offset(r, t), cornerPaint);
    canvas.drawLine(Offset(r, t), Offset(r, t + cornerLen), cornerPaint);
    // Canto inferior-esquerdo
    canvas.drawLine(Offset(l, b - cornerLen), Offset(l, b), cornerPaint);
    canvas.drawLine(Offset(l, b), Offset(l + cornerLen, b), cornerPaint);
    // Canto inferior-direito
    canvas.drawLine(Offset(r - cornerLen, b), Offset(r, b), cornerPaint);
    canvas.drawLine(Offset(r, b), Offset(r, b - cornerLen), cornerPaint);
  }

  @override
  bool shouldRepaint(_ViewfinderOverlay old) =>
      detected != old.detected || accentColor != old.accentColor;
}
