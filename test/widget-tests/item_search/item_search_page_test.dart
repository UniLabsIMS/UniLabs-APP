import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/item.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/item_search/components/item_details.dart';
import 'package:unilabs_app/views/item_search/item_search_page.dart';

import '../../bloc-tests/test_data/logged_in_root_state.dart';

class MockItemSearchBloc extends MockBloc<ItemSearchEvent, ItemSearchState>
    implements ItemSearchBloc {}

class ItemSearchStateFake extends Fake implements ItemSearchState {}

class ItemSearchEventFake extends Fake implements ItemSearchEvent {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Item Search - Item Search Page', () {
    MockItemSearchBloc mockItemSearchBloc;
    MockRootBloc mockRootBloc;
    Item item;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      registerFallbackValue<ItemSearchState>(ItemSearchStateFake());
      registerFallbackValue<ItemSearchEvent>(ItemSearchEventFake());
      mockItemSearchBloc = MockItemSearchBloc();
      mockRootBloc = MockRootBloc();
      item = Item(
        id: "xxx",
        state: ItemRepository.AvailableState,
        parentDisplayItemName: "name",
        parentDisplayItemDescription: "desc",
        parentDisplayItemImageURL: "",
        categoryName: "cat name",
        labName: loggedInRootState.user.lab,
      );
    });
    testWidgets('Item Search Page renders as expected when item is not scanned',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        ItemSearchState(
          error: "",
          loading: false,
          searchError: false,
          deleteError: false,
          deletionSuccess: false,
          stateChangeSuccess: false,
          stateChangeError: false,
          item: null,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ItemSearchPage();
      final widgetFinder = find.byType(ItemSearchPage);
      final textFinder = find.text(
        'Item Search',
        skipOffstage: false,
      );
      final scannerFinder = find.byType(TapToScanCard, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemSearchBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: Scaffold(body: widget),
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

    testWidgets('Item Search Page renders as expected when item is scanned',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        ItemSearchState(
          error: "",
          loading: false,
          searchError: false,
          deleteError: false,
          deletionSuccess: false,
          stateChangeSuccess: false,
          stateChangeError: false,
          item: item,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ItemSearchPage();
      final widgetFinder = find.byType(ItemSearchPage);
      final textFinder = find.text(
        'Item Search',
        skipOffstage: false,
      );
      final detailsFinder = find.byType(ItemDetails, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemSearchBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: Scaffold(body: widget),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(detailsFinder, findsOneWidget);
    });

    testWidgets('Item Search Page renders as expected when loading is true',
        (WidgetTester tester) async {
      when(() => mockItemSearchBloc.state).thenReturn(
        ItemSearchState(
          error: "",
          loading: true,
          searchError: false,
          deleteError: false,
          deletionSuccess: false,
          stateChangeSuccess: false,
          stateChangeError: false,
          item: null,
        ),
      );

      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = ItemSearchPage();
      final widgetFinder = find.byType(ItemSearchPage);
      final textFinder = find.text(
        'Item Search',
        skipOffstage: false,
      );
      final loadingFinder =
          find.byType(CircularProgressIndicator, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<ItemSearchBloc>(
            create: (context) => mockItemSearchBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: Scaffold(body: widget),
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
