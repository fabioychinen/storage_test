import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';
import 'package:storage_test/domain/usecases/add_product.dart';
import 'package:storage_test/domain/usecases/load_products.dart';
import 'package:storage_test/domain/usecases/remove_product.dart';
import 'package:storage_test/main.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';

class InMemoryProductRepository implements ProductRepository {
  final List<Product> _products = [];
  int _nextId = 1;

  @override
  Future<List<Product>> loadProducts() async => List.of(_products);

  @override
  Future<Product> addProduct(Product product) async {
    final added = Product(
      id: _nextId++,
      name: product.name,
      quantity: product.quantity,
      barcode: product.barcode,
    );
    _products.add(added);
    return added;
  }

  @override
  Future<void> removeProduct(int id) async {
    _products.removeWhere((product) => product.id == id);
  }
}

void main() {
  testWidgets(
    'add product -> appears on product list -> delete removes it',
    (WidgetTester tester) async {
      final repository = InMemoryProductRepository();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProductBloc(
                loadProducts: LoadProducts(repository),
                addProduct: AddProduct(repository),
                removeProduct: RemoveProduct(repository),
              ),
            ),
            BlocProvider(create: (_) => BarcodeBloc()),
          ],
          child: const WarehouseApp(),
        ),
      );

      await tester.tap(find.text('Adicionar produtos'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'Nome do produto'), 'Parafuso');
      await tester.enterText(
          find.widgetWithText(TextField, 'Quantidade'), '10');
      await tester.enterText(
          find.widgetWithText(TextField, 'Digite o código de barras'),
          '12345');

      await tester.tap(find.text('Adicionar produto'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lista de Produtos'));
      await tester.pumpAndSettle();

      expect(find.text('Parafuso'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Parafuso'), findsNothing);
    },
  );
}
