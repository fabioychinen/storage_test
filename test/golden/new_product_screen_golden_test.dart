import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/presentation/screens/new_product/new_product_screen.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('NewProductScreen golden', () {
    testWidgets('formulário vazio - light', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(buildTestApp(home: const NewProductScreen()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NewProductScreen),
        matchesGoldenFile('goldens/new_product_light.png'),
      );
    });

    testWidgets('formulário vazio - dark', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(
          home: const NewProductScreen(),
          themeMode: ThemeMode.dark,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NewProductScreen),
        matchesGoldenFile('goldens/new_product_dark.png'),
      );
    });
  });
}