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
    return ListTile(
      title: Text(product.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeProduct(context),
      ),
      onTap: () => _openDetails(context),
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
