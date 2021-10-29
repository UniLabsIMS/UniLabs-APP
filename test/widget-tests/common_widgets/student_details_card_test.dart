import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';

void main() {
  group('Common Widget - StudentDetailCard', () {
    testWidgets('StudentDetailCard renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = StudentDetailCard(
        firstName: "firstName",
        lastName: "lastName",
        studentID: "studentID",
        department: "department",
        imgSrc: "",
      );
      final widgetFinder = find.byType(StudentDetailCard);
      final imageFinder = find.byType(
        NetworkAvatar,
        skipOffstage: false,
      );
      final nameFinder = find.text(widget.firstName + ' ' + widget.lastName);
      final studentDetailFinder =
          find.text(widget.studentID + ' - ' + widget.department);

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
      expect(nameFinder, findsOneWidget);
      expect(studentDetailFinder, findsOneWidget);
    });
  });
}
