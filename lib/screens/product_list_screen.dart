import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/data/product_sqlite_datasource.dart';
import 'package:storage_test/models/product.dart';
import 'package:storage_test/screens/product_detail_screen.dart';
import '../blocs/product_bloc.dart';
import '../blocs/product_events.dart';
import '../blocs/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, required List productList});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductBloc _bloc;
  late List<Product> productList;
  @override
  void initState() {
    super.initState();
    _bloc = ProductBloc();
    _bloc.add(LoadProductEvent());
    _loadProductsFromDatabase();
  }

  Future<void> _loadProductsFromDatabase() async {
    final products = await ProductSqliteDatasource.instance.getProducts();
    setState(() {
      productList = products;
    });
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
                      icon: Image.asset('assets/images/delete.png.png'),
                      onPressed: () {
                        _bloc.add(
                            RemoveProductEvent(product: productList[index]));
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
