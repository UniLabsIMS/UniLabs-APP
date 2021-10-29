import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';

void main() {
  group('Common Widget - NetworkAvatar', () {
    testWidgets('NetworkAvatar renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = NetworkAvatar(
        radius: 30,
        src:
            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
        err: "err",
        borderWidth: 5,
      );
      final widgetFinder = find.byType(NetworkAvatar);
      final circularAvatarFinder = find.byType(
        CircleAvatar,
        skipOffstage: false,
      );
      final imageFinder = find.byType(
        Image,
        skipOffstage: false,
      );
      final errorText = find.text(widget.err, skipOffstage: false);

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
      expect(imageFinder, findsOneWidget);
      expect(errorText, findsOneWidget);
      expect(circularAvatarFinder, findsNWidgets(2));
      expect(
        (tester.firstWidget(circularAvatarFinder) as CircleAvatar).radius,
        widget.radius + widget.borderWidth,
      );
    });
  });
}
