import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/screens/update_stock/widgets/update_stock_tile.dart';
import 'package:storage_test/presentation/widgets/empty_product_list.dart';

class UpdateStockScreen extends StatefulWidget {
  const UpdateStockScreen({super.key});

  @override
  State<UpdateStockScreen> createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  int? _updatingId;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openUpdateDialog(Product product) async {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<ProductBloc>();
    int qty = 1;
    final qtyController = TextEditingController(text: '1');

    final confirmed = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text(CoreStrings.addOnStock),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Estoque atual: ${product.quantity ?? 0} un.',
                style: TextStyle(color: colorScheme.outline, fontSize: 13),
              ),
              const SizedBox(height: 20),
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
                          setDialogState(() => qty = parsed);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    icon: const Icon(Icons.add),
                    onPressed: () {
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
              onPressed: () => Navigator.pop(ctx, qty),
              child: const Text(CoreStrings.addOnStock),
            ),
          ],
        ),
      ),
    );

    qtyController.dispose();
    if (confirmed == null || !mounted) return;

    setState(() => _updatingId = product.id);
    bloc.add(UpdateStockEvent(productId: product.id!, quantity: confirmed));
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
        title: const Text(CoreStrings.addOnStock, style: CoreFonts.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: CoreStrings.searchProducts,
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
              ],
              onChanged: (value) => setState(() => _searchQuery = value),
              elevation: const WidgetStatePropertyAll(1),
            ),
          ),
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (_updatingId == null) return;
                setState(() => _updatingId = null);
                if (state is ProductSuccessState) {
                  _showSnackBar(CoreStrings.stockUpdatedSuccess, isError: false);
                } else if (state is ProductErrorState) {
                  _showSnackBar(state.message, isError: true);
                }
              },
              builder: (context, state) {
                if (state is ProductSuccessState) {
                  final filtered = _searchQuery.isEmpty
                      ? state.products
                      : state.products
                          .where((p) => p.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) return const EmptyProductList();
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ProductBloc>().add(LoadProductEvent()),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return UpdateStockTile(
                          product: product,
                          isUpdating: _updatingId == product.id,
                          onUpdate: () => _openUpdateDialog(product),
                        );
                      },
                    ),
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
          ),
        ],
      ),
    );
  }
}