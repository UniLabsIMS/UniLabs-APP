import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';

void main() {
  group('Common Widget - CustomSmallButton', () {
    Function fn = () => {print("Test")};
    testWidgets('CustomSmallButton renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = CustomSmallButton(
        color: Colors.red,
        text: "Button Text",
        onPressed: fn,
      );
      final widgetFinder = find.byType(CustomSmallButton);
      final rawButtonFinder = find.byType(
        ElevatedButton,
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
      expect(rawButtonFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(
        (tester.widget(rawButtonFinder) as ElevatedButton).onPressed,
        widget.onPressed,
      );
    });
  });
}
