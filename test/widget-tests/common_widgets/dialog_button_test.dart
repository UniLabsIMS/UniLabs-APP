import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';

void main() {
  group('Common Widget - DialogButton', () {
    Function fn = () => {print("Test")};
    testWidgets('DialogButton renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = DialogButton(
        color: Colors.red,
        text: "Button Text",
        onPressed: fn,
      );
      final widgetFinder = find.byType(DialogButton);
      final rawButtonFinder = find.byType(
        TextButton,
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
        (tester.widget(rawButtonFinder) as TextButton).onPressed,
        widget.onPressed,
      );
      expect(
        (tester.widget(titleFinder) as Text).style.color,
        widget.color,
      );
    });
  });
}
