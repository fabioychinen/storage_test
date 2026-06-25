import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/screens/delete_product/widgets/delete_tile.dart';
import 'package:storage_test/presentation/widgets/empty_product_list.dart';

class DeleteProductScreen extends StatefulWidget {
  const DeleteProductScreen({super.key});

  @override
  State<DeleteProductScreen> createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  int? _deletingId;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductEvent());
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(CoreStrings.confirmDeletion),
        content: Text(CoreStrings.confirmRemovalOf(product.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(CoreStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(CoreStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deletingId = product.id);
    context.read<ProductBloc>().add(DeleteProductEvent(productId: product.id!));
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CoreStrings.deleteProducts, style: CoreFonts.title),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (_deletingId == null) return;
          setState(() => _deletingId = null);
          if (state is ProductSuccessState) {
            _showSnackBar(CoreStrings.productDeletedSuccess, isError: false);
          } else if (state is ProductErrorState) {
            _showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is ProductSuccessState) {
            if (state.products.isEmpty) return const EmptyProductList();
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return DeleteTile(
                  product: product,
                  isDeleting: _deletingId == product.id,
                  onDelete: () => _confirmDelete(product),
                );
              },
            );
          }
          if (state is ProductErrorState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 56),
                  const SizedBox(height: 12),
                  const Text(CoreStrings.loadProductsError),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        context.read<ProductBloc>().add(LoadProductEvent()),
                    child: const Text(CoreStrings.tryAgain),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}