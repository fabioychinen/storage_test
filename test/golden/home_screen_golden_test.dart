import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/presentation/screens/home/home_screen.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('HomeScreen golden', () {
    testWidgets('light theme', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(buildTestApp(home: const HomeScreen()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_light.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(home: const HomeScreen(), themeMode: ThemeMode.dark),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_dark.png'),
      );
    });

    testWidgets('drawer aberto', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(buildTestApp(home: const HomeScreen()));
      await tester.pumpAndSettle();

      final scaffoldState =
          tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/home_drawer.png'),
      );
    });
  });
}