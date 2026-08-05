import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isProcessing = false;

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    final hour = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$min';
  }

  Future<int?> _showQuantityDialog({required bool isEntry}) async {
    int qty = 1;
    final colorScheme = Theme.of(context).colorScheme;
    final maxQty = !isEntry ? (widget.product.quantity ?? 0) : null;
    final qtyController = TextEditingController(text: '1');

    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEntry ? CoreStrings.quickEntry : CoreStrings.quickExit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Estoque atual: ${widget.product.quantity ?? 0} un.',
                style: TextStyle(color: colorScheme.outline, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    icon: const Icon(Icons.remove),
                    onPressed: qty <= 1
                        ? null
                        : () {
                            setDialogState(() => qty--);
                            qtyController.text = '$qty';
                          },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 72,
                    child: TextField(
                      controller: qtyController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed >= 1) {
                          if (maxQty == null || parsed <= maxQty) {
                            setDialogState(() => qty = parsed);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    icon: const Icon(Icons.add),
                    onPressed: (maxQty != null && qty >= maxQty)
                        ? null
                        : () {
                            setDialogState(() => qty++);
                            qtyController.text = '$qty';
                          },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(CoreStrings.cancel),
            ),
            FilledButton(
              style: isEntry
                  ? null
                  : FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                    ),
              onPressed: () => Navigator.pop(ctx, qty),
              child: Text(isEntry ? CoreStrings.quickEntry : CoreStrings.remove),
            ),
          ],
        ),
      ),
    );

    qtyController.dispose();
    return result;
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
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
    final colorScheme = Theme.of(context).colorScheme;
    final product = widget.product;

    final hasLastUpdate = product.lastUpdatedAt != null &&
        product.lastUpdatedByEmail != null &&
        product.lastUpdateType != null;
    final isAdd = product.lastUpdateType == 'add';

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (!_isProcessing) return;
        setState(() => _isProcessing = false);
        if (state is ProductSuccessState) {
          _showSnackBar(CoreStrings.stockUpdatedSuccess, isError: false);
          Navigator.pop(context);
        } else if (state is ProductErrorState) {
          _showSnackBar(state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(CoreStrings.productDetails, style: CoreFonts.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Quantidade em destaque
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${product.quantity ?? 0}',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                          height: 1,
                        ),
                      ),
                      Text(
                        'unidades',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Ações rápidas
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () async {
                              final bloc = context.read<ProductBloc>();
                              final qty = await _showQuantityDialog(isEntry: true);
                              if (qty == null || !mounted) return;
                              setState(() => _isProcessing = true);
                              bloc.add(UpdateStockEvent(
                                  productId: product.id!, quantity: qty));
                            },
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.add),
                      label: const Text(CoreStrings.quickEntry),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isProcessing || (product.quantity ?? 0) <= 0
                          ? null
                          : () async {
                              final bloc = context.read<ProductBloc>();
                              final qty =
                                  await _showQuantityDialog(isEntry: false);
                              if (qty == null || !mounted) return;
                              setState(() => _isProcessing = true);
                              bloc.add(CollectProductEvent(
                                  productId: product.id!, quantity: qty));
                            },
                      icon: const Icon(Icons.remove),
                      label: const Text(CoreStrings.quickExit),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Informações do produto
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.qr_code_2_outlined),
                      title: Text(CoreStrings.barcodeOf(product.barcode)),
                    ),
                    if (product.addedByEmail != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined),
                        title: const Text(CoreStrings.addedBy),
                        subtitle: Text(product.addedByEmail!),
                      ),
                    ],
                    if (hasLastUpdate) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          isAdd
                              ? Icons.add_circle_outline
                              : Icons.remove_circle_outline,
                          color: isAdd ? Colors.green : Colors.orange,
                        ),
                        title: Text(
                          isAdd
                              ? CoreStrings.stockAdded
                              : CoreStrings.stockCollected,
                        ),
                        subtitle: Text(
                          '${product.lastUpdatedByEmail!}\n${_formatDate(product.lastUpdatedAt!)}',
                        ),
                        isThreeLine: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
