import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/models/product.dart';
import 'package:storage_test/screens/product_detail_screen.dart';
import 'package:storage_test/blocs/product_bloc.dart';
import 'package:storage_test/blocs/product_events.dart';
import 'package:storage_test/blocs/product_state.dart';

class ProductListScreen extends StatefulWidget {
  final List<Product> productList;

  const ProductListScreen({Key? key, required this.productList})
      : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProductBloc();
    _bloc.add(LoadProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Produtos',
          style: TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: BlocBuilder<ProductBloc, ProductState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is ProductInitialState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProductSuccessState) {
                final productList = state.product;
                return ListView.separated(
                  itemCount: productList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(productList[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _bloc.add(RemoveProductEvent(
                            product: productList[index], productId: 1));
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: productList[index]),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (_, __) => const Divider(),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
