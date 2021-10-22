import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockBuildContext mockContext;
  MockUserRepository mockUserRepository;

  setUp(() async {
    mockContext = MockBuildContext();
    mockUserRepository = MockUserRepository();
  });

  group('Root Bloc', () {
    blocTest<RootBloc, RootState>(
      'when \'CheckStartedEvent\' the state field \'checkStarted\' should be set to true.',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(CheckStartedEvent()),
      expect: () => [
        isA<RootState>()
            .having((state) => state.checkStarted, 'checkStarted', equals(true))
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'UpdateUserEvent\' user object should be set in state',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateUserEvent(rootTestUser)),
      expect: () => [
        isA<RootState>()
            .having((state) => state.user, 'user', equals(rootTestUser))
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'ChangeLogInStateEvent\' is called to log in  \'loginState\' should be set to LOGIN',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ChangeLogInStateEvent(LoginStateType.LOGIN)),
      expect: () => [
        isA<RootState>().having((state) => state.loginState, 'loginState',
            equals(LoginStateType.LOGIN))
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'ChangeLogInStateEvent\' is called to log out \'loginState\' should be set to LOGOUT',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ChangeLogInStateEvent(LoginStateType.LOGOUT)),
      expect: () => [
        isA<RootState>().having((state) => state.loginState, 'loginState',
            equals(LoginStateType.LOGOUT))
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'ChangeLogInStateEvent\' is called to start login check \'loginState\' should be set to CHECKING',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ChangeLogInStateEvent(LoginStateType.CHECKING)),
      expect: () => [
        isA<RootState>().having((state) => state.loginState, 'loginState',
            equals(LoginStateType.CHECKING))
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'LogInAndSaveTokenEvent\' user object should be set in state',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(LogInAndSaveTokenEvent(rootTestUser)),
      expect: () => [
        isA<RootState>()
            .having((state) => state.loginState, 'loginState',
                equals(LoginStateType.LOGIN))
            .having((state) => state.user, 'user', equals(rootTestUser)),
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'LogOutEvent\' the state field \'loginState\' should be set to LOGOUT.',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(LogOutEvent()),
      expect: () => [
        isA<RootState>().having((state) => state.loginState, 'loginState',
            equals(LoginStateType.CHECKING)),
        isA<RootState>().having((state) => state.loginState, 'loginState',
            equals(LoginStateType.LOGOUT)),
      ],
    );

    blocTest<RootBloc, RootState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        RootBloc bloc = RootBloc(mockContext, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorRootEvent("Error String")),
      expect: () => [
        isA<RootState>().having((state) => state.error, 'error', equals("")),
        isA<RootState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

User rootTestUser = User(
  id: "33a59268-8b84-48fe-8b96-8ab221edd249",
  token: "367dd9e9f8d3eb6927d721ff44fcaedbbad9d33c74f66ef20be1474cf000422a",
  email: "test@example.com",
  firstName: "Test",
  lastName: "User",
  imageURL: null,
  role: "Lab_Assistant",
  department: "Computer Science and Engineering",
  lab: "Embedded Systems Laboratory",
  labId: "",
  contactNo: "0777546342",
  blocked: false,
);
