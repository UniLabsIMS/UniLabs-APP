import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/home/bloc/home_bloc.dart';
import 'package:unilabs_app/views/home/bloc/home_state.dart';
import 'package:unilabs_app/views/home/bloc/home_event.dart';

import 'test_data/logged_in_root_state.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockUserRepository extends Mock implements UserRepository {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockBuildContext mockContext;
  MockRootBloc mockRootBloc;
  MockUserRepository mockUserRepository;

  setUp(() async {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockRootBloc = MockRootBloc();
    mockUserRepository = MockUserRepository();
  });

  group('Home Bloc', () {
    blocTest<HomeBloc, HomeState>(
      'when \'LogoutEvent\' successful, RootBloc \'LogOutEvent\' must be triggered.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockUserRepository.logOut(
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );
        HomeBloc bloc = HomeBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.logoutError, 'loginFailed', equals(false)),
      ],
      verify: (_) {
        verify(() => mockRootBloc.add(captureAny(that: isA<LogOutEvent>())))
            .called(1);
        verify(() => mockUserRepository.logOut(
            token: any(
                named: 'token',
                that: equals(loggedInRootState.user.token)))).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'when \'LogoutEvent\' error,  \'logoutError\' field in state must be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockUserRepository.logOut(
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );
        HomeBloc bloc = HomeBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.logoutError, 'loginFailed', equals(false)),
        isA<HomeState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.logoutError, 'loginFailed', equals(true)),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        HomeBloc bloc = HomeBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<HomeState>().having((state) => state.error, 'error', equals("")),
        isA<HomeState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}
