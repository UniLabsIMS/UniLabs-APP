import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:unilabs_app/views/item_search/components/item_different_lab_warning.dart';
import 'package:mocktail/mocktail.dart';

class MockItemSearchBloc extends MockBloc<ItemSearchEvent, ItemSearchState>
    implements ItemSearchBloc {}

class ItemSearchStateFake extends Fake implements ItemSearchState {}

class ItemSearchEventFake extends Fake implements ItemSearchEvent {}

void main() {
  group('Item Search - Different Lab Warning', () {
    MockItemSearchBloc mockItemSearchBloc;

    setUpAll(() {
      registerFallbackValue<ItemSearchState>(ItemSearchStateFake());
      registerFallbackValue<ItemSearchEvent>(ItemSearchEventFake());
      mockItemSearchBloc = MockItemSearchBloc();
    });
    testWidgets('Different Lab Warning renders as expected',
        (WidgetTester tester) async {
      // find
      final widget = ItemOfDifferentLabWarning();
      final widgetFinder = find.byType(ItemOfDifferentLabWarning);
      final textFinder = find.text(
          'The item scanned does not belong to your lab. Please rescan an item belonging to your lab.',
          skipOffstage: false);
      final iconFinder = find.byType(Icon, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<ItemSearchBloc>(
          create: (context) => mockItemSearchBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: widget,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
    });
  });
}
