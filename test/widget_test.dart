// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:droid_gangwar_flutter/main.dart';
import 'package:droid_gangwar_flutter/providers/game_provider.dart';

void main() {
  testWidgets('Game app builds without errors', (WidgetTester tester) async {
    // Build our app with ChangeNotifierProvider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameProvider(),
        child: const MyApp(),
      ),
    );

    // Verify that the app builds without errors
    expect(find.byType(MyApp), findsOneWidget);

    // Just pump once to allow the widget tree to build
    await tester.pump();

    // The app should build successfully
    expect(tester.takeException(), isNull);
  });
}
