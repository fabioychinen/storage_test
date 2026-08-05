import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.scale(scale: 0.85 + 0.15 * value, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 72,
                  color: scheme.onPrimary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Estoque',
                style: CoreFonts.title.copyWith(
                  fontSize: 40,
                  color: scheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gestão de Armazém',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.65),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
