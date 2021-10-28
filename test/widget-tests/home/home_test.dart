import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/home/bloc/home_bloc.dart';
import 'package:unilabs_app/views/home/bloc/home_event.dart';
import 'package:unilabs_app/views/home/bloc/home_state.dart';
import 'package:unilabs_app/views/home/components/menu_tile.dart';
import 'package:unilabs_app/views/home/components/profile_card.dart';
import 'package:unilabs_app/views/home/home.dart';

import '../../bloc-tests/test_data/logged_in_root_state.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class HomeStateFake extends Fake implements HomeState {}

class HomeEventFake extends Fake implements HomeEvent {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Home - Main Widget', () {
    MockHomeBloc mockHomeBloc;
    MockRootBloc mockRootBloc;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      registerFallbackValue<HomeState>(HomeStateFake());
      registerFallbackValue<HomeEvent>(HomeEventFake());
      mockHomeBloc = MockHomeBloc();
      mockRootBloc = MockRootBloc();
    });

    testWidgets('should render home as expected when no error',
        (WidgetTester tester) async {
      // arrange

      when(() => mockHomeBloc.state).thenReturn(
        HomeState(error: "", loading: false, logoutError: false),
      );
      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = HomePage();
      final profileCardWidget = find.byType(ProfileCard);
      final textWidget = find.text('UniLabs');
      final menuTilesWidgets = find.byType(MenuTile, skipOffstage: false);
      final logoutButton = find.text('Log Out', skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(profileCardWidget, findsOneWidget);
      expect(textWidget, findsOneWidget);
      expect(menuTilesWidgets, findsNWidgets(4));
      expect(logoutButton, findsOneWidget);
    });

    testWidgets('should render home as expected when loading is true',
        (WidgetTester tester) async {
      // arrange

      when(() => mockHomeBloc.state).thenReturn(
        HomeState(error: "", loading: true, logoutError: false),
      );
      when(() => mockRootBloc.state).thenReturn(
        loggedInRootState,
      );

      // find
      final widget = HomePage();
      final loadingWidget =
          find.byType(CircularProgressIndicator, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );

      // expect
      expect(loadingWidget, findsOneWidget);
    });
  });
}
