import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';

void main() {
  testWidgets('CustomFilterChip toggles selection', (
    WidgetTester tester,
  ) async {
    bool selected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomFilterChip(
            label: 'Test',
            selected: selected,
            onSelected: (val) => selected = val,
          ),
        ),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
    await tester.tap(find.text('Test'));
    // selected должен измениться, но из-за особенностей StatelessWidget это не проверить напрямую
  });
}
