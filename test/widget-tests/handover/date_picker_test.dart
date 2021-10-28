import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/components/date_picker.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHandoverBloc extends MockBloc<HandoverEvent, HandoverState>
    implements HandoverBloc {}

class HandoverStateFake extends Fake implements HandoverState {}

class HandoverEventFake extends Fake implements HandoverEvent {}

void main() {
  group('Handover - Date Picker', () {
    MockHandoverBloc mockHandoverBloc;

    setUpAll(() {
      registerFallbackValue<HandoverState>(HandoverStateFake());
      registerFallbackValue<HandoverEvent>(HandoverEventFake());
      mockHandoverBloc = MockHandoverBloc();
    });
    testWidgets('Date Picker renders as expected', (WidgetTester tester) async {
      when(() => mockHandoverBloc.state).thenReturn(
        HandoverState(
          error: "",
          step: HandoverProcessStep.ItemScanStep,
          loading: false,
          student: new Student(),
          selectedApprovedDisplayItem: new ApprovedDisplayItem(),
          approvedDisplayItemsList: [new ApprovedDisplayItem()],
          studentIDScanError: false,
          itemScanError: false,
          itemScanSuccess: false,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: false,
          dueDate: "2021-10-20",
        ),
      );

      // find
      final widget = DatePicker();
      final widgetFinder = find.byType(DatePicker);
      final dueDateFinder =
          find.text("Due Date: 2021-10-20", skipOffstage: false);
      final editTextFinder =
          find.text("Tap to Edit Due Date", skipOffstage: false);
      final pickerFinder = find.byType(GestureDetector, skipOffstage: false);

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
      expect(dueDateFinder, findsOneWidget);
      expect(editTextFinder, findsOneWidget);
      expect(pickerFinder, findsOneWidget);
    });
  });
}
