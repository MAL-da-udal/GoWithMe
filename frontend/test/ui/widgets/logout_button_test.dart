import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/widgets/logout_button.dart';

void main() {
  testWidgets('LogoutButton renders and shows dialog on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LogoutButton(),
        ),
      ),
    );
    expect(find.byType(LogoutButton), findsOneWidget);
    await tester.tap(find.byType(LogoutButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Вы уверены, что хотите выйти?'), findsOneWidget);
  });
}

