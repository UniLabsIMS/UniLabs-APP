import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/handover/components/student_and_item_details.dart';
import 'package:unilabs_app/views/handover/step_pages/intial_page.dart';

class MockHandoverBloc extends MockBloc<HandoverEvent, HandoverState>
    implements HandoverBloc {}

class HandoverStateFake extends Fake implements HandoverState {}

class HandoverEventFake extends Fake implements HandoverEvent {}

void main() {
  group('Handover - InitialPage', () {
    MockHandoverBloc mockHandoverBloc;
    Student student;

    setUpAll(() {
      registerFallbackValue<HandoverState>(HandoverStateFake());
      registerFallbackValue<HandoverEvent>(HandoverEventFake());
      mockHandoverBloc = MockHandoverBloc();

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
        'InitialPage renders as expected when no student id is scanned yet',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: null,
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
      final widget = InitialPage();
      final widgetFinder = find.byType(InitialPage);
      final scanCardFinder = find.byType(TapToScanCard, skipOffstage: false);
      final titleFinder = find.text("Item Handover", skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: widget,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(scanCardFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });
    testWidgets('InitialPage renders as expected when a student id is scanned',
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
      final widget = InitialPage();
      final widgetFinder = find.byType(InitialPage);
      final detailsFinder =
          find.byType(StudentAndItemDetails, skipOffstage: false);
      final titleFinder = find.text("Item Handover", skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: widget,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(detailsFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('InitialPage renders as expected when a loading is true',
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
      final widget = InitialPage();
      final widgetFinder = find.byType(InitialPage);
      final loadingFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);
      final titleFinder = find.text("Item Handover", skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<HandoverBloc>(
          create: (context) => mockHandoverBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: widget,
          ),
        ),
      );

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(loadingFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });
  });
}
