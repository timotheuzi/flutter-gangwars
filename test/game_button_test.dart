import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gangwar/widgets/game_button.dart';

void main() {
  group('GameButton', () {
    testWidgets('renders label and icon without layout overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: GameButton(
                text: 'ENTER 3D WORLD',
                icon: Icons.terrain,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('ENTER 3D WORLD'), findsOneWidget);
      expect(find.byIcon(Icons.terrain), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shrinks long labels instead of overflowing when constrained', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 150,
                child: GameButton(
                  text: 'ENTER 3D WORLD',
                  icon: Icons.terrain,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('ENTER 3D WORLD'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('invokes onPressed when tapped', (WidgetTester tester) async {
      var taps = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: GameButton(text: 'QUIT', onPressed: () => taps++),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(taps, 1);
    });
  });
}
