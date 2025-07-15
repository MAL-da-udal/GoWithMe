import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/widgets/icon_back.dart';

void main() {
  testWidgets('IconBack renders and triggers callback', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: IconBack(callback: () => tapped = true)),
      ),
    );
    expect(find.byType(IconBack), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    expect(tapped, true);
  });
}
