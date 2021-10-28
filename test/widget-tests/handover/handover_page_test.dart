import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/handover/handover_page.dart';
import 'package:unilabs_app/views/handover/step_pages/intial_page.dart';
import 'package:unilabs_app/views/handover/step_pages/item_scan_page.dart';

class MockHandoverBloc extends MockBloc<HandoverEvent, HandoverState>
    implements HandoverBloc {}

class HandoverStateFake extends Fake implements HandoverState {}

class HandoverEventFake extends Fake implements HandoverEvent {}

void main() {
  group('Handover - HandoverPage', () {
    MockHandoverBloc mockHandoverBloc;
    Student student;
    ApprovedDisplayItem approvedDisplayItemOne;
    ApprovedDisplayItem approvedDisplayItemTwo;
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
      approvedDisplayItemOne = new ApprovedDisplayItem(
        id: "xxx",
        displayItemName: "name",
        displayItemImageURL: "",
        displayItemId: "yyy",
        displayItemDescription: "desc",
        requestedItemCount: 4,
      );
      approvedDisplayItemTwo = new ApprovedDisplayItem(
        id: "xxx2",
        displayItemName: "name2",
        displayItemImageURL: "",
        displayItemId: "yyy2",
        displayItemDescription: "desc2",
        requestedItemCount: 5,
      );
    });
    testWidgets('HandoverPage renders as expected when step is InitialStep',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.InitialStep,
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
      final widget = HandoverPage();
      final widgetFinder = find.byType(HandoverPage);
      final childPageFinder = find.byType(InitialPage, skipOffstage: false);
      final animationFinder =
          find.byType(AnimatedSwitcher, skipOffstage: false);

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
      expect(childPageFinder, findsOneWidget);
      expect(animationFinder, findsOneWidget);
    });

    testWidgets('HandoverPage renders as expected when step is ItemScanStep',
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
      final widget = HandoverPage();
      final widgetFinder = find.byType(HandoverPage);
      final childPageFinder = find.byType(ItemScanPage, skipOffstage: false);
      final animationFinder =
          find.byType(AnimatedSwitcher, skipOffstage: false);

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
      expect(childPageFinder, findsOneWidget);
      expect(animationFinder, findsOneWidget);
    });
  });
}
