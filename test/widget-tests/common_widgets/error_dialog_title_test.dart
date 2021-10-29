import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/constants.dart';

void main() {
  group('Common Widget - ErrorDialogTitle', () {
    testWidgets('ErrorDialogTitle renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = ErrorDialogTitle(
        title: "Lorem Ipsum",
      );
      final widgetFinder = find.byType(ErrorDialogTitle);
      final iconFinder = find.byType(Icon, skipOffstage: false);
      final titleFinder = find.text(widget.title, skipOffstage: false);

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
      expect(
        (tester.widget(iconFinder) as Icon).icon,
        FontAwesomeIcons.times,
      );
      expect(
        (tester.widget(iconFinder) as Icon).color,
        Constants.kErrorColor,
      );
    });
  });
}
