import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';

class EmptyProductList extends StatelessWidget {
  const EmptyProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 56, color: colorScheme.outline),
          const SizedBox(height: 12),
          const Text(CoreStrings.emptyProductList, style: CoreFonts.body),
        ],
      ),
    );
  }
}