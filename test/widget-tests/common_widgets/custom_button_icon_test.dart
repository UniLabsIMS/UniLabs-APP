import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';

void main() {
  group('Common Widget - CustomIconButton', () {
    Function fn = () => {print("Test")};
    testWidgets('CustomIconButton renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = CustomIconButton(
        icon: Icons.add,
        text: "Button Text",
        onTap: fn,
      );
      final widgetFinder = find.byType(CustomIconButton);
      final iconFinder = find.byType(Icon, skipOffstage: false);
      final inkwellFinder = find.byType(
        InkWell,
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
      expect(iconFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(inkwellFinder, findsOneWidget);
      expect(
        (tester.widget(inkwellFinder) as InkWell).onTap,
        fn,
      );
      expect(
        (tester.widget(iconFinder) as Icon).icon,
        Icons.add,
      );
    });
  });
}
