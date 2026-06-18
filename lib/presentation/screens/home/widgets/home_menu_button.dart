import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';

class HomeMenuButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback onPressed;

  const HomeMenuButton({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Image.asset(
                iconAsset,
                width: 24,
                height: 24,
                color: colorScheme.onSurface,
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label, style: CoreFonts.body),
              ),
              Icon(Icons.chevron_right, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
