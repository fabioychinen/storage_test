import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/screens/update_stock/update_stock_screen.dart';

import '../helpers/app_wrapper.dart';

final _products = [
  Product(id: 1, name: 'Parafuso M8', quantity: 150, barcode: 1001),
  Product(id: 2, name: 'Porca M8', quantity: 80, barcode: 1002),
];

void main() {
  group('UpdateStockScreen golden', () {
    testWidgets('lista vazia - light', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(buildTestApp(home: const UpdateStockScreen()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(UpdateStockScreen),
        matchesGoldenFile('goldens/update_stock_empty_light.png'),
      );
    });

    testWidgets('lista com produtos - light', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(
          home: const UpdateStockScreen(),
          products: _products,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(UpdateStockScreen),
        matchesGoldenFile('goldens/update_stock_light.png'),
      );
    });

    testWidgets('lista com produtos - dark', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(
          home: const UpdateStockScreen(),
          products: _products,
          themeMode: ThemeMode.dark,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(UpdateStockScreen),
        matchesGoldenFile('goldens/update_stock_dark.png'),
      );
    });
  });
}