
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la3byStore/main.dart';

void main() {
  testWidgets('La3byStore Navigation Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Toy Catalog'), findsOneWidget);
    expect(find.text('Welcome, Guest'), findsOneWidget);
  });
}