import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/views/item_search/components/state_bubble.dart';

void main() {
  group('Item Search - State Bubble', () {
    testWidgets('State Bubble renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = StateBubble(
        stateName: 'Borrowed',
        color: Colors.red,
      );
      final widgetFinder = find.byType(StateBubble);
      final titleFinder = find.text('Borrowed', skipOffstage: false);
      final containerFinder = find.byType(Container, skipOffstage: false);

      // test
      await tester.pumpWidget(
        MaterialApp(
          title: 'Widget Test',
          home: Scaffold(body: widget),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(containerFinder, findsOneWidget);
      expect(
          ((tester.firstWidget(containerFinder) as Container).decoration
                  as BoxDecoration)
              .color,
          Colors.red);
    });
  });
}
