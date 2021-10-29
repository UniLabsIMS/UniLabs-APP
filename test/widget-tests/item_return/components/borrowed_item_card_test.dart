import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/views/item_return/components/borrowed_item_card.dart';

void main() {
  group('Item Return - Borrowed Item Card', () {
    testWidgets('Borrowed Item Card renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = BorrowedItemCard(
        displayItemName: "dsp name",
        itemID: "xxx",
        dueDate: "2021-10-20",
        state: "Borrowed",
      );
      final widgetFinder = find.byType(BorrowedItemCard);
      final idFinder = find.text(widget.itemID);
      final stateFinder = find.text(widget.state);
      final detailFinder =
          find.text(widget.displayItemName + " \nDue on: " + widget.dueDate);

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
      expect(idFinder, findsOneWidget);
      expect(stateFinder, findsOneWidget);
      expect(detailFinder, findsOneWidget);
    });
  });
}
