import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/login/bloc/login_bloc.dart';
import 'package:unilabs_app/views/login/bloc/login_event.dart';
import 'package:unilabs_app/views/login/bloc/login_state.dart';
import 'package:unilabs_app/views/login/login.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class LoginStateFake extends Fake implements LoginState {}

class LoginEventFake extends Fake implements LoginEvent {}

class RootStateFake extends Fake implements RootState {}

class RootEventFake extends Fake implements RootEvent {}

void main() {
  group('Log In - Main Widget', () {
    MockLoginBloc mockLoginBloc;
    MockRootBloc mockRootBloc;

    setUpAll(() {
      registerFallbackValue<RootState>(RootStateFake());
      registerFallbackValue<RootEvent>(RootEventFake());
      registerFallbackValue<LoginState>(LoginStateFake());
      registerFallbackValue<LoginEvent>(LoginEventFake());
      mockLoginBloc = MockLoginBloc();
      mockRootBloc = MockRootBloc();
    });

    testWidgets('should render login as expected when no error',
        (WidgetTester tester) async {
      // arrange

      when(() => mockLoginBloc.state).thenReturn(LoginState(
        error: "",
        showPass: false,
        loginFailed: false,
        loading: false,
        isArchived: false,
      ));
      when(() => mockRootBloc.state).thenReturn(RootState(
        error: "",
        user: null,
        loginState: LoginStateType.LOGOUT,
        checkStarted: false,
      ));

      // find
      final widget = LoginPage();
      final textFieldWidgets = find.byType(TextFormField, skipOffstage: false);
      final loginButton = find.byType(CustomIconButton, skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<LoginBloc>(
            create: (context) => mockLoginBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // expect
      expect(textFieldWidgets, findsNWidgets(2));
      expect(loginButton, findsOneWidget);
    });

    testWidgets('should render login with error message when login failed',
        (WidgetTester tester) async {
      // arrange

      when(() => mockLoginBloc.state).thenReturn(LoginState(
        error: "",
        showPass: false,
        loginFailed: true,
        loading: false,
        isArchived: false,
      ));
      when(() => mockRootBloc.state).thenReturn(RootState(
        error: "",
        user: null,
        loginState: LoginStateType.LOGOUT,
        checkStarted: false,
      ));

      // find
      final widget = LoginPage();
      final errorWidget =
          find.text('Email or Password is Incorrect.', skipOffstage: false);

      // test
      await tester.pumpWidget(
        BlocProvider<RootBloc>(
          create: (context) => mockRootBloc,
          child: BlocProvider<LoginBloc>(
            create: (context) => mockLoginBloc,
            child: MaterialApp(
              title: 'Widget Test',
              home: widget,
            ),
          ),
        ),
      );

      // expect
      expect(errorWidget, findsOneWidget);
    });
  });
}
