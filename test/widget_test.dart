import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intuitive_todo/main.dart';

void main() {
  testWidgets('Intuitive Todo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IntuitiveTodoApp());

    // Verify that the app title is displayed
    expect(find.text('Intuitive Todo'), findsOneWidget);
    
    // Verify that the main screen loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
