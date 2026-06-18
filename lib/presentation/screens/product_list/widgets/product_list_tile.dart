import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/screens/product_detail/product_detail_screen.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

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
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          child: const Icon(Icons.inventory_2_outlined),
        ),
        title: Text(product.name),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          onPressed: () => _removeProduct(context),
        ),
        onTap: () => _openDetails(context),
      ),
    );
  }

  void _removeProduct(BuildContext context) {
    context
        .read<ProductBloc>()
        .add(RemoveProductEvent(productId: product.id!));
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }
}
