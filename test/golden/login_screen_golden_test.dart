import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/presentation/screens/login/login_screen.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('LoginScreen golden', () {
    testWidgets('modo login - light', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(home: const LoginScreen(), user: User(id: '', email: '')),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_light.png'),
      );
    });

    testWidgets('modo login - dark', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(
          home: const LoginScreen(),
          themeMode: ThemeMode.dark,
          user: User(id: '', email: ''),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_dark.png'),
      );
    });

    testWidgets('modo cadastro - light', (tester) async {
      setGoldenDevice(tester);

      await tester.pumpWidget(
        buildTestApp(home: const LoginScreen(), user: User(id: '', email: '')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Criar conta'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_register_light.png'),
      );
    });
  });
}