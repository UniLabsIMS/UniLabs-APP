import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';

void main() {
  group('Common Widget - AlertDialogBody', () {
    testWidgets('AlertDialogBody renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = AlertDialogBody(
        content: "Lorem Ipsum",
      );
      final widgetFinder = find.byType(AlertDialogBody);
      final titleFinder = find.text(widget.content);

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
    });
  });
}
