import 'package:flutter/material.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/screens/product_list/widgets/product_list_tile.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;

  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) =>
          ProductListTile(product: products[index]),
    );
  }
}
