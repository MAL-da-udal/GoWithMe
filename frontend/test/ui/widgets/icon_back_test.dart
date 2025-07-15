import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/widgets/icon_back.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('IconBack triggers callback if provided', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IconBack(callback: () => tapped = true),
        ),
      ),
    );
    await tester.tap(find.byType(IconButton));
    expect(tapped, true);
  });

  testWidgets('IconBack navigates if callback is not provided', (WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => Scaffold(body: IconBack())),
        GoRoute(path: '/home', builder: (context, state) => const SizedBox()),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.byType(IconButton));
    // Можно проверить, что не возникло ошибок
  });
}