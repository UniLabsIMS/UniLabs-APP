import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/views/home/components/profile_card.dart';

void main() {
  group('Home - Profile Card', () {
    testWidgets('Profile Card renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = ProfileCard(
        firstName: "test",
        lastName: "name",
        labName: "lab test name",
        imgSrc: "",
      );
      final widgetFinder = find.byType(ProfileCard);
      final nameFinder = find.text("test name");
      final labNameFinder = find.text("lab test name");
      final imageContainerFinder = find.byType(NetworkAvatar);

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
      expect(nameFinder, findsOneWidget);
      expect(labNameFinder, findsOneWidget);
      expect(imageContainerFinder, findsOneWidget);
    });
  });
}
