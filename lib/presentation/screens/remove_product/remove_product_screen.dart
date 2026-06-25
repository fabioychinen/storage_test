import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/screens/remove_product/widgets/collect_tile.dart';
import 'package:storage_test/presentation/widgets/empty_product_list.dart';

class CollectProductScreen extends StatefulWidget {
  const CollectProductScreen({super.key});

  @override
  State<CollectProductScreen> createState() => _CollectProductScreenState();
}

class _CollectProductScreenState extends State<CollectProductScreen> {
  int? _collectingId;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductEvent());
  }

  Future<void> _openCollectDialog(Product product) async {
    final controller = TextEditingController(text: '1');
    final confirmed = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(CoreStrings.confirmRemoval),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Estoque atual: ${product.quantity ?? 0} un.',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.outline,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: CoreStrings.quantityToRemove,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.remove_circle_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(CoreStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () {
              final amount = int.tryParse(controller.text);
              Navigator.pop(ctx, amount);
            },
            child: const Text(CoreStrings.remove),
          ),
        ],
      ),
    );

    if (confirmed == null || !mounted) return;

    if (confirmed <= 0) {
      _showSnackBar(CoreStrings.invalidQuantity, isError: true);
      return;
    }
    if (confirmed > (product.quantity ?? 0)) {
      _showSnackBar(CoreStrings.insufficientStock, isError: true);
      return;
    }

    setState(() => _collectingId = product.id);
    context.read<ProductBloc>().add(
          CollectProductEvent(productId: product.id!, quantity: confirmed),
        );
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
        title: const Text(CoreStrings.removeProducts, style: CoreFonts.title),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (_collectingId == null) return;
          setState(() => _collectingId = null);
          if (state is ProductSuccessState) {
            _showSnackBar(CoreStrings.productRemovedSuccess, isError: false);
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
                return CollectTile(
                  product: product,
                  isCollecting: _collectingId == product.id,
                  onCollect: () => _openCollectDialog(product),
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