import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';

void main() {
  group('Common Widget - TapToScanCard', () {
    Function fn = () => {print("Test")};
    testWidgets('TapToScanCard renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = TapToScanCard(
        text: "Button Text",
        onTap: fn,
        fontSize: 33,
      );
      final widgetFinder = find.byType(TapToScanCard);
      final gestureDetectorFinder = find.byType(
        GestureDetector,
        skipOffstage: false,
      );
      final titleFinder = find.text(widget.text);

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
      expect(gestureDetectorFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(
        (tester.widget(gestureDetectorFinder) as GestureDetector).onTap,
        widget.onTap,
      );
      expect(
        (tester.widget(titleFinder) as Text).style.fontSize,
        widget.fontSize,
      );
    });
  });
}
