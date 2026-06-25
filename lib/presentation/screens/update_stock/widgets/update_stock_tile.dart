import 'package:flutter/material.dart';
import 'package:storage_test/domain/entities/product.dart';

class UpdateStockTile extends StatelessWidget {
  final Product product;
  final bool isUpdating;
  final VoidCallback onUpdate;

  const UpdateStockTile({
    super.key,
    required this.product,
    required this.isUpdating,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.inventory_2_outlined),
        ),
        title: Text(product.name),
        subtitle: Text(
          '${product.quantity ?? 0} un.',
          style: TextStyle(color: colorScheme.outline),
        ),
        trailing: isUpdating
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            : IconButton(
                icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                onPressed: onUpdate,
              ),
      ),
    );
  }
}