import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/views/handover/components/approved_display_item_card.dart';

void main() {
  group('Handover - Approved Display Item Card', () {
    testWidgets('Approved Display Item Card renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = ApprovedDisplayItemCard(
        displayItemName: "test name",
        requestedQuantity: '5',
        onTap: null,
        imgSrc: "",
      );
      final widgetFinder = find.byType(ApprovedDisplayItemCard);
      final displayItemNameFinder = find.text("test name", skipOffstage: false);
      final quantityTextFinder = find.text("Quantity: 05", skipOffstage: false);
      final imageContainerFinder =
          find.byType(NetworkAvatar, skipOffstage: false);

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
      expect(displayItemNameFinder, findsOneWidget);
      expect(quantityTextFinder, findsOneWidget);
      expect(imageContainerFinder, findsOneWidget);
    });
  });
}
