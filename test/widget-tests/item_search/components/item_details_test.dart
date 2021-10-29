import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/classes/api/item.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:unilabs_app/views/item_search/components/item_details.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/views/item_search/components/item_different_lab_warning.dart';

import '../../../bloc-tests/test_data/logged_in_root_state.dart';

class MockItemSearchBloc extends MockBloc<ItemSearchEvent, ItemSearchState>
    implements ItemSearchBloc {}

class ItemSearchStateFake extends Fake implements ItemSearchState {}

class ItemSearchEventFake extends Fake implements ItemSearchEvent {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Item Search - Item Details', () {
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
    testWidgets(
        'Item Details Widget renders as expected when item has state "Available"',
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
      final widget = ItemDetails();
      final widgetFinder = find.byType(ItemDetails);
      final parentTextFinder = find.text(
        item.parentDisplayItemName.toUpperCase(),
        skipOffstage: false,
      );
      final idTextFinder = find.text(
        item.id,
        skipOffstage: false,
      );
      final descTextFinder = find.text(
        item.parentDisplayItemDescription,
        skipOffstage: false,
      );
      final imageFinder = find.byType(NetworkAvatar, skipOffstage: false);
      final buttonFinder = find.byType(CustomSmallButton, skipOffstage: false);
      final iconButtonFinder =
          find.byType(CustomIconButton, skipOffstage: false);

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
      expect(parentTextFinder, findsOneWidget);
      expect(idTextFinder, findsOneWidget);
      expect(descTextFinder, findsOneWidget);
      expect(imageFinder, findsOneWidget);
      expect(iconButtonFinder, findsOneWidget);
      expect(buttonFinder, findsNWidgets(2));
      expect((tester.firstWidget(buttonFinder) as CustomSmallButton).text,
          "Mark Item as Damaged");
      expect((tester.widget(iconButtonFinder) as CustomIconButton).text,
          "Scan Another");
    });

    testWidgets(
        'Item Details Widget renders as expected when item has state "Damaged"',
        (WidgetTester tester) async {
      item.state = ItemRepository.DamagedState;
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
      final widget = ItemDetails();
      final widgetFinder = find.byType(ItemDetails);
      final parentTextFinder = find.text(
        item.parentDisplayItemName.toUpperCase(),
        skipOffstage: false,
      );
      final idTextFinder = find.text(
        item.id,
        skipOffstage: false,
      );
      final descTextFinder = find.text(
        item.parentDisplayItemDescription,
        skipOffstage: false,
      );
      final imageFinder = find.byType(NetworkAvatar, skipOffstage: false);
      final buttonFinder = find.byType(CustomSmallButton, skipOffstage: false);
      final iconButtonFinder =
          find.byType(CustomIconButton, skipOffstage: false);

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
      expect(parentTextFinder, findsOneWidget);
      expect(idTextFinder, findsOneWidget);
      expect(descTextFinder, findsOneWidget);
      expect(imageFinder, findsOneWidget);
      expect(iconButtonFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
      expect((tester.widget(buttonFinder) as CustomSmallButton).text,
          "Mark Item Available");
      expect((tester.widget(iconButtonFinder) as CustomIconButton).text,
          "Scan Another");
    });

    testWidgets(
        'Item Details Widget renders as expected when item is from another lab',
        (WidgetTester tester) async {
      item.labName = "yyy";
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
      final widget = ItemDetails();
      final widgetFinder = find.byType(ItemDetails);

      final warningFinder =
          find.byType(ItemOfDifferentLabWarning, skipOffstage: false);

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
      expect(warningFinder, findsOneWidget);
    });
  });
}
