import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/splash.dart';

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Splash Widget', () {
    MockRootBloc mockRootBloc;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      mockRootBloc = MockRootBloc();
    });

    testWidgets('should render home as expected when no error',
        (WidgetTester tester) async {
      // arrange

      when(() => mockRootBloc.state).thenReturn(
        RootState(
          error: "",
          user: null,
          loginState: LoginStateType.LOGOUT,
          checkStarted: false,
        ),
      );

      // find
      final widget = SplashScreen();
      final widgetFinder = find.byType(SplashScreen);
      final textWidgetFinder = find.text('UniLabs', skipOffstage: false);
      final subTextWidgetFinder =
          find.text('Inventory Management System', skipOffstage: false);
      final heroWidgetFinder = find.byType(Hero, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: MaterialApp(
            title: 'Widget Test',
            home: widget,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(widgetFinder, findsOneWidget);
      expect(textWidgetFinder, findsOneWidget);
      expect(subTextWidgetFinder, findsOneWidget);
      expect(heroWidgetFinder, findsOneWidget);
    });
  });
}
