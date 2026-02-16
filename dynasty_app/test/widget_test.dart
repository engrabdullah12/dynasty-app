import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dynasty_app/main.dart';

void main() {
  testWidgets('DynastyX app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DynastyXApp());

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
