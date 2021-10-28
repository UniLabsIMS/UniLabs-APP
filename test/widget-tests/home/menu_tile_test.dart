import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/views/home/components/menu_tile.dart';

void main() {
  group('Home - Menu Tile', () {
    testWidgets('Menu Tile renders as expected', (WidgetTester tester) async {
      // find
      final widget = MenuTile(
          title: "Test",
          onTap: null,
          image: AssetImage('assets/images/search_item.jpg'));
      final widgetFinder = find.byType(MenuTile);
      final titleFinder = find.text("Test");
      final imageContainerFinder = find.byType(Container);

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
      expect(imageContainerFinder, findsOneWidget);
    });
  });
}
