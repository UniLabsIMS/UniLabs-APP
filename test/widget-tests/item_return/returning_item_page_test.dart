import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_bloc.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_event.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_state.dart';
import 'package:unilabs_app/views/item_return/components/item_acceptance_scan_view.dart';
import 'package:unilabs_app/views/item_return/returning_item_page.dart';
import '../../bloc-tests/test_data/logged_in_root_state.dart';

class MockItemReturnBloc extends MockBloc<ItemReturnEvent, ItemReturnState>
    implements ItemReturnBloc {}

class ItemReturnStateFake extends Fake implements ItemReturnState {}

class ItemReturnEventFake extends Fake implements ItemReturnEvent {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Item Return - Item Return Page', () {
    MockItemReturnBloc mockItemReturnBloc;
    MockRootBloc mockRootBloc;
    Student student;
    BorrowedItem borrowedItem;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      registerFallbackValue<ItemReturnState>(ItemReturnStateFake());
      registerFallbackValue<ItemReturnEvent>(ItemReturnEventFake());
      mockItemReturnBloc = MockItemReturnBloc();
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
      borrowedItem = new BorrowedItem(
        id: 'hhh',
        state: "Borrowed",
        dueDate: "2021-10-09",
        displayItemName: "name",
        displayItemImageURL: "",
      );
    });
    testWidgets(
        'Item Return Page renders as expected when student id is not scanned',
        (WidgetTester tester) async {
      when(() => mockItemReturnBloc.state).thenReturn(
        ItemReturnState(
          error: "",
          loading: false,
          studentSearchSuccess: false,
          studentSearchError: false,
          itemAcceptanceSuccess: false,
          itemAcceptanceError: false,
          student: null,
          borrowedItems: [],
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ReturningItemPage();
      final widgetFinder = find.byType(ReturningItemPage);
      final textFinder = find.text(
        'Returning Items',
        skipOffstage: false,
      );
      final scannerFinder = find.byType(TapToScanCard, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemReturnBloc>(
            create: (context) => mockItemReturnBloc,
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
        'Item Return Page renders as expected when student id is scanned',
        (WidgetTester tester) async {
      when(() => mockItemReturnBloc.state).thenReturn(
        ItemReturnState(
          error: "",
          loading: false,
          studentSearchSuccess: false,
          studentSearchError: false,
          itemAcceptanceSuccess: false,
          itemAcceptanceError: false,
          student: student,
          borrowedItems: [borrowedItem],
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ReturningItemPage();
      final widgetFinder = find.byType(ReturningItemPage);
      final textFinder = find.text(
        'Returning Items',
        skipOffstage: false,
      );
      final viewFinder =
          find.byType(ItemAcceptanceScanView, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemReturnBloc>(
            create: (context) => mockItemReturnBloc,
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
      expect(viewFinder, findsOneWidget);
    });

    testWidgets('Item Return Page renders as expected when loading is true',
        (WidgetTester tester) async {
      when(() => mockItemReturnBloc.state).thenReturn(
        ItemReturnState(
          error: "",
          loading: true,
          studentSearchSuccess: false,
          studentSearchError: false,
          itemAcceptanceSuccess: false,
          itemAcceptanceError: false,
          student: student,
          borrowedItems: [borrowedItem],
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ReturningItemPage();
      final widgetFinder = find.byType(ReturningItemPage);
      final textFinder = find.text(
        'Returning Items',
        skipOffstage: false,
      );
      final loadingFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemReturnBloc>(
            create: (context) => mockItemReturnBloc,
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
