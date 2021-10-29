import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/components/approved_display_item_card.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/handover/components/student_and_item_details.dart';

class MockHandoverBloc extends MockBloc<HandoverEvent, HandoverState>
    implements HandoverBloc {}

class HandoverStateFake extends Fake implements HandoverState {}

class HandoverEventFake extends Fake implements HandoverEvent {}

void main() {
  group('Handover - StudentAndItemDetails', () {
    MockHandoverBloc mockHandoverBloc;
    ApprovedDisplayItem approvedDisplayItemOne;
    ApprovedDisplayItem approvedDisplayItemTwo;
    Student student;

    setUpAll(() {
      registerFallbackValue<HandoverState>(HandoverStateFake());
      registerFallbackValue<HandoverEvent>(HandoverEventFake());
      mockHandoverBloc = MockHandoverBloc();
      approvedDisplayItemOne = new ApprovedDisplayItem(
          id: "xxx",
          displayItemName: "name",
          displayItemImageURL: "",
          displayItemId: "yyy",
          displayItemDescription: "desc",
          requestedItemCount: 4);
      approvedDisplayItemTwo = new ApprovedDisplayItem(
          id: "xxx2",
          displayItemName: "name2",
          displayItemImageURL: "",
          displayItemId: "yyy2",
          displayItemDescription: "desc2",
          requestedItemCount: 5);
      student = new Student(
        id: 'xxx',
        firstName: "first",
        lastName: "last",
        imageURL: "",
        indexNumber: "180000",
        email: "test@ex.com",
        departmentCode: "CSE",
        departmentName: "CompSci",
        contactNo: "0777456345",
      );
    });
    testWidgets(
        'StudentAndItemDetails renders as expected when a list of approved display items are present',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: student,
          selectedApprovedDisplayItem: approvedDisplayItemOne,
          approvedDisplayItemsList: [
            approvedDisplayItemOne,
            approvedDisplayItemTwo
          ],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: false,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = StudentAndItemDetails();
      final widgetFinder = find.byType(StudentAndItemDetails);
      final studentDetailCardFinder =
          find.byType(StudentDetailCard, skipOffstage: false);
      final buttonFinder = find.byType(CustomSmallButton, skipOffstage: false);
      final approvedDisplayItemsTextFinder =
          find.text("Approved Display Items", skipOffstage: false);
      final approvedDisplayItemsCardsFinder =
          find.byType(ApprovedDisplayItemCard, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: Scaffold(body: widget),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(studentDetailCardFinder, findsOneWidget);
      expect(buttonFinder, findsNWidgets(2));
      expect(approvedDisplayItemsTextFinder, findsOneWidget);
      expect(approvedDisplayItemsCardsFinder, findsNWidgets(2));
    });

    testWidgets(
        'StudentAndItemDetails renders as expected when a list of approved display items are not present',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: student,
          selectedApprovedDisplayItem: null,
          approvedDisplayItemsList: [],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: false,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = StudentAndItemDetails();
      final widgetFinder = find.byType(StudentAndItemDetails);
      final studentDetailCardFinder =
          find.byType(StudentDetailCard, skipOffstage: false);
      final noApprovedDisplayItemsTextFinder = find.text(
          "No Approved Items Available for this Student.",
          skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: Scaffold(body: widget),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(studentDetailCardFinder, findsOneWidget);
      expect(noApprovedDisplayItemsTextFinder, findsOneWidget);
    });

    testWidgets(
        'StudentAndItemDetails renders as expected when loading is true',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: true,
          student: student,
          selectedApprovedDisplayItem: null,
          approvedDisplayItemsList: [],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: false,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = StudentAndItemDetails();
      final widgetFinder = find.byType(StudentAndItemDetails);
      final loadingWidgetFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: Scaffold(body: widget),
          ),
        ),
      );

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(loadingWidgetFinder, findsOneWidget);
    });

    testWidgets(
        'StudentAndItemDetails renders as expected when clearAllApprovedError is true',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: student,
          selectedApprovedDisplayItem: approvedDisplayItemOne,
          approvedDisplayItemsList: [
            approvedDisplayItemOne,
            approvedDisplayItemTwo
          ],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: true,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = StudentAndItemDetails();
      final widgetFinder = find.byType(StudentAndItemDetails);
      final errorTextFinder = find.text(
          "Could not clear all approved items.Try again later.",
          skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: Scaffold(body: widget),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(errorTextFinder, findsOneWidget);
    });

    testWidgets(
        'StudentAndItemDetails renders as expected when clearAllApprovedSuccess is true',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: student,
          selectedApprovedDisplayItem: approvedDisplayItemOne,
          approvedDisplayItemsList: [
            approvedDisplayItemOne,
            approvedDisplayItemTwo
          ],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: true,
          clearAllApprovedError: false,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = StudentAndItemDetails();
      final widgetFinder = find.byType(StudentAndItemDetails);
      final successTextFinder = find.text(
        "All Approved Items Cleared",
        skipOffstage: false,
      );

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: Scaffold(body: widget),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(successTextFinder, findsOneWidget);
    });
  });
}
