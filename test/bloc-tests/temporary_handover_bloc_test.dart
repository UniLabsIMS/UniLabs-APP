import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_bloc.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_state.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_event.dart';
import 'test_data/logged_in_root_state.dart';
import 'test_data/student.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockStudentRepository extends Mock implements StudentRepository {}

class MockBuildContext extends Mock implements BuildContext {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockItemRepository mockItemRepository;
  MockBuildContext mockContext;
  MockRootBloc mockRootBloc;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockRootBloc = MockRootBloc();
    mockItemRepository = MockItemRepository();
    mockStudentRepository = MockStudentRepository();
  });

  group('Temporary Handover Bloc', () {
    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'StudentIDScanEvent\' successful, student object should be set to \'student\' field of state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockStudentRepository.getFromAPI(
            studentID: testStudent.indexNumber,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => testStudent,
        );

        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(StudentIDScanEvent(scannedID: testStudent.indexNumber)),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false)),
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(true))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false))
            .having((state) => state.student, 'student', equals(testStudent)),
      ],
    );

    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'StudentIDScanEvent\' error, \'studentSearchError\' field of state should be set top true',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockStudentRepository.getFromAPI(
            studentID: testStudent.indexNumber,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(StudentIDScanEvent(scannedID: testStudent.indexNumber)),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false)),
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(true)),
      ],
    );

    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'ScanAndTempHandoverItemEvent\' successful,\'handoverSuccess\' field of state should be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.tempHandover(
            itemID: scannedItemID,
            studentUUID: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );

        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(ScanAndTempHandoverItemEvent(scannedID: scannedItemID)),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.handoverSuccess, 'handoverSuccess',
                equals(false))
            .having(
                (state) => state.handoverError, 'handoverError', equals(false)),
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.handoverSuccess, 'handoverSuccess',
                equals(true))
            .having(
                (state) => state.handoverError, 'handoverError', equals(false)),
      ],
    );

    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'ScanAndTempHandoverItemEvent\' error,\'handoverError\' field of state should be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.tempHandover(
            itemID: scannedItemID,
            studentUUID: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(ScanAndTempHandoverItemEvent(scannedID: scannedItemID)),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.handoverSuccess, 'handoverSuccess',
                equals(false))
            .having(
                (state) => state.handoverError, 'handoverError', equals(false)),
        isA<TemporaryHandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.handoverSuccess, 'handoverSuccess',
                equals(false))
            .having(
                (state) => state.handoverError, 'handoverError', equals(true)),
      ],
    );

    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'ResetStateEvent\' state should be reset to initial state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );

        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) => bloc.add(ResetStateEvent()),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.error, 'error', equals(""))
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.student, 'student', equals(null))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false))
            .having((state) => state.handoverSuccess, 'handoverSuccess',
                equals(false))
            .having(
                (state) => state.handoverError, 'handoverError', equals(false)),
      ],
    );

    blocTest<TemporaryHandoverBloc, TemporaryHandoverState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        TemporaryHandoverBloc bloc = TemporaryHandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<TemporaryHandoverState>()
            .having((state) => state.error, 'error', equals("")),
        isA<TemporaryHandoverState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

const String scannedItemID = "RteF4563";
TemporaryHandoverState studentIDScannedState = TemporaryHandoverState(
    error: "",
    loading: false,
    studentSearchSuccess: false,
    studentSearchError: false,
    handoverSuccess: false,
    handoverError: false,
    student: testStudent);
