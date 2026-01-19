import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tasty_trail/app.dart';

void main() {
  testWidgets('TastyTrail app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
