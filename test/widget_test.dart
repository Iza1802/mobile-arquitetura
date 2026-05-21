import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_app/main.dart';

void main() {
  testWidgets('LoginPage renderiza com botão Entrar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Entrar'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
