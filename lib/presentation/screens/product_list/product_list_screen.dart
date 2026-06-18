import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/screens/product_list/widgets/product_list_view.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          CoreStrings.productList,
          style: CoreFonts.title,
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductSuccessState) {
            if (state.products.isEmpty) {
              return const _EmptyProductList();
            }
            return ProductListView(products: state.products);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _EmptyProductList extends StatelessWidget {
  const _EmptyProductList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 56,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text(
            CoreStrings.emptyProductList,
            style: CoreFonts.body,
          ),
        ],
      ),
    );
  }
}
