import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/login/bloc/login_bloc.dart';
import 'package:unilabs_app/views/login/bloc/login_event.dart';
import 'package:unilabs_app/views/login/bloc/login_state.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockUserRepository extends Mock implements UserRepository {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockBuildContext mockContext;
  MockUserRepository mockUserRepository;
  MockRootBloc mockRootBloc;

  setUp(() async {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockUserRepository = MockUserRepository();
    mockRootBloc = MockRootBloc();
  });

  group('Root Bloc', () {
    blocTest<LoginBloc, LoginState>(
      'when \'TogglePasswordVisiblityEvent\' the state field \'showPass\' should be set as true if its false.',
      build: () {
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(TogglePasswordVisiblityEvent()),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.showPass, 'showPass', equals(true))
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'when \'TogglePasswordVisiblityEvent\' the state field \'showPass\' should be set as fasle if its true.',
      build: () {
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        bloc.emit(bloc.state.clone(showPass: true));
        return bloc;
      },
      act: (bloc) => bloc.add(TogglePasswordVisiblityEvent()),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.showPass, 'showPass', equals(false))
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'when \'SubmitEvent\' successful, RootBloc \'LogInAndSaveTokenEvent\' must be triggered.',
      build: () {
        when(
          () => mockUserRepository.loginToWithEmailPassword(
              loginTestUser.email, loginPassword),
        ).thenAnswer(
          (_) async => loginTestUser,
        );
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(SubmitEvent(
          {'email': loginTestUser.email, 'password': loginPassword})),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.loginFailed, 'loginFailed', equals(false)),
      ],
      verify: (_) {
        verify(() => mockRootBloc
            .add(captureAny(that: isA<LogInAndSaveTokenEvent>()))).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'when \'SubmitEvent\' error, \'loginFailed\' state field should be set to true.',
      build: () {
        when(
          () => mockUserRepository.loginToWithEmailPassword(
              loginTestUser.email, loginPassword),
        ).thenAnswer(
          (_) async => null,
        );
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(SubmitEvent(
          {'email': loginTestUser.email, 'password': loginPassword})),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.loginFailed, 'loginFailed', equals(false)),
        isA<LoginState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.loginFailed, 'loginFailed', equals(true)),
      ],
      verify: (_) {
        verifyNever(() =>
            mockRootBloc.add(captureAny(that: isA<LogInAndSaveTokenEvent>())));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'when \'SubmitEvent\' returns a non Lab_Assistant user , \'loginFailed\' state field should be set to true.',
      build: () {
        when(
          () => mockUserRepository.loginToWithEmailPassword(
              loginTestUser.email, loginPassword),
        ).thenAnswer(
          (_) async => nonLabAssistantUser,
        );
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(SubmitEvent(
          {'email': loginTestUser.email, 'password': loginPassword})),
      expect: () => [
        isA<LoginState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.loginFailed, 'loginFailed', equals(false)),
        isA<LoginState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.loginFailed, 'loginFailed', equals(true)),
      ],
      verify: (_) {
        verifyNever(() =>
            mockRootBloc.add(captureAny(that: isA<LogInAndSaveTokenEvent>())));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        LoginBloc bloc =
            LoginBloc(mockContext, mockRootBloc, mockUserRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<LoginState>().having((state) => state.error, 'error', equals("")),
        isA<LoginState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

User loginTestUser = User(
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

User nonLabAssistantUser = User(
  id: "33a59268-8b84-48fe-8b96-8ab221edd249",
  token: "367dd9e9f8d3eb6927d721ff44fcaedbbad9d33c74f66ef20be1474cf000422a",
  email: "test@example.com",
  firstName: "Test",
  lastName: "User",
  imageURL: null,
  role: "Student",
  department: "Computer Science and Engineering",
  lab: "Embedded Systems Laboratory",
  labId: "",
  contactNo: "0777546342",
  blocked: false,
);
const String loginPassword = "#ThYbgEH";
