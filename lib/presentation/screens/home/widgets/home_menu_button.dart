import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';

class HomeMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const HomeMenuButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: CoreFonts.body),
      ),
    );
  }
}
