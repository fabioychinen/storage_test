import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';
import 'package:storage_test/presentation/screens/product_list/product_list_screen.dart';
import 'package:storage_test/presentation/screens/remove_product/remove_product_screen.dart';
import 'package:storage_test/presentation/screens/delete_product/delete_product_screen.dart';

import 'helpers/app_wrapper.dart';

void main() {
  testWidgets('adicionar produto → aparece na lista de produtos',
      (tester) async {
    await tester.pumpWidget(buildTestApp(home: const HomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CoreStrings.addNewProducts));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, CoreStrings.productName), 'Parafuso');
    await tester.enterText(
        find.widgetWithText(TextField, CoreStrings.quantity), '10');
    await tester.enterText(
        find.widgetWithText(TextField, CoreStrings.enterBarcode), '12345');

    await tester.tap(find.text(CoreStrings.addProduct));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CoreStrings.productList));
    await tester.pumpAndSettle();

    expect(find.text('Parafuso'), findsOneWidget);
  });

  testWidgets('remover produto → some da lista', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        home: const DeleteProductScreen(),
        products: [Product(id: 1, name: 'Porca', quantity: 5, barcode: 99999)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Porca'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CoreStrings.delete));
    await tester.pumpAndSettle();

    expect(find.text('Porca'), findsNothing);
  });

  testWidgets('coletar produto → quantidade reduz', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        home: const CollectProductScreen(),
        products: [Product(id: 1, name: 'Arruela', quantity: 20, barcode: 77777)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('20 un.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_circle_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CoreStrings.remove));
    await tester.pumpAndSettle();

    expect(find.text('19 un.'), findsOneWidget);
  });

  testWidgets('lista de produtos exibe todos os itens carregados',
      (tester) async {
    final products = [
      Product(id: 1, name: 'Item A', quantity: 10, barcode: 111),
      Product(id: 2, name: 'Item B', quantity: 5, barcode: 222),
    ];

    await tester.pumpWidget(
      buildTestApp(home: const ProductListScreen(), products: products),
    );
    await tester.pumpAndSettle();

    expect(find.text('Item A'), findsOneWidget);
    expect(find.text('Item B'), findsOneWidget);
  });
}