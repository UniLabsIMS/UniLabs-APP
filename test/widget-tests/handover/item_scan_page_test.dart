import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/handover/step_pages/item_scan_page.dart';

class MockHandoverBloc extends MockBloc<HandoverEvent, HandoverState>
    implements HandoverBloc {}

class HandoverStateFake extends Fake implements HandoverState {}

class HandoverEventFake extends Fake implements HandoverEvent {}

void main() {
  group('Handover - ItemScanPage', () {
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
    testWidgets('ItemScanPage renders as expected when loading is false',
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
      final widget = ItemScanPage();
      final widgetFinder = find.byType(ItemScanPage);
      final scanCardFinder = find.byType(TapToScanCard, skipOffstage: false);

      final titleTextFinder = find.text("Item Scan", skipOffstage: false);
      final remainingItemCountTileTextFinder =
          find.text("Remaining Requested Item Count", skipOffstage: false);
      final remainingItemCountTextFinder = find.text("04", skipOffstage: false);

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
      expect(titleTextFinder, findsOneWidget);
      expect(remainingItemCountTileTextFinder, findsOneWidget);
      expect(remainingItemCountTextFinder, findsOneWidget);
    });

    testWidgets('ItemScanPage renders as expected when loading is true',
        (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: true,
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
      final widget = ItemScanPage();
      final widgetFinder = find.byType(ItemScanPage);
      final loadingWidgetFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);

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
      expect(loadingWidgetFinder, findsOneWidget);
    });
  });
}
