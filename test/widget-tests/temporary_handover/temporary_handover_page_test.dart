import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_bloc.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_event.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_state.dart';
import 'package:unilabs_app/views/temporary_handover/components/item_scan_view.dart';
import 'package:unilabs_app/views/temporary_handover/temporary_handover_page.dart';

import '../../bloc-tests/test_data/logged_in_root_state.dart';

class MockTemporaryHandoverBloc
    extends MockBloc<TemporaryHandoverEvent, TemporaryHandoverState>
    implements TemporaryHandoverBloc {}

class TemporaryHandoverStateFake extends Fake
    implements TemporaryHandoverState {}

class TemporaryHandoverEventFake extends Fake
    implements TemporaryHandoverEvent {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Temporary Handover - Temporary Handover Page', () {
    MockTemporaryHandoverBloc mockItemSearchBloc;
    MockRootBloc mockRootBloc;
    Student student;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      registerFallbackValue<TemporaryHandoverState>(
          TemporaryHandoverStateFake());
      registerFallbackValue<TemporaryHandoverEvent>(
          TemporaryHandoverEventFake());
      mockItemSearchBloc = MockTemporaryHandoverBloc();
      mockRootBloc = MockRootBloc();
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
        'Temporary Handover Page renders as expected when student id is not scanned',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        TemporaryHandoverState(
          error: "",
          loading: false,
          studentSearchSuccess: false,
          studentSearchError: false,
          handoverSuccess: false,
          handoverError: false,
          student: null,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = TemporaryHandoverPage();
      final widgetFinder = find.byType(TemporaryHandoverPage);
      final textFinder = find.text(
        'Temporary Handover',
        skipOffstage: false,
      );
      final scannerFinder = find.byType(TapToScanCard, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<TemporaryHandoverBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(scannerFinder, findsOneWidget);
    });

    testWidgets(
        'Temporary Handover Page renders as expected when student id is scanned',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        TemporaryHandoverState(
          error: "",
          loading: false,
          studentSearchSuccess: false,
          studentSearchError: false,
          handoverSuccess: false,
          handoverError: false,
          student: student,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = TemporaryHandoverPage();
      final widgetFinder = find.byType(TemporaryHandoverPage);
      final textFinder = find.text(
        'Temporary Handover',
        skipOffstage: false,
      );
      final scanViewFinder = find.byType(ItemScanView, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<TemporaryHandoverBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(scanViewFinder, findsOneWidget);
    });

    testWidgets(
        'Temporary Handover Page renders as expected when loading is true',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        TemporaryHandoverState(
          error: "",
          loading: true,
          studentSearchSuccess: false,
          studentSearchError: false,
          handoverSuccess: false,
          handoverError: false,
          student: student,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = TemporaryHandoverPage();
      final widgetFinder = find.byType(TemporaryHandoverPage);
      final textFinder = find.text(
        'Temporary Handover',
        skipOffstage: false,
      );
      final loadingFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<TemporaryHandoverBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(loadingFinder, findsOneWidget);
    });
  });
}
