import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';
import 'package:unilabs_app/classes/repository/borrowed_item_repository.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_bloc.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_state.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_event.dart';
import 'test_data/logged_in_root_state.dart';
import 'test_data/student.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockStudentRepository extends Mock implements StudentRepository {}

class MockBorrowedItemRepository extends Mock
    implements BorrowedItemRepository {}

class MockBuildContext extends Mock implements BuildContext {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockItemRepository mockItemRepository;
  MockBuildContext mockContext;
  MockRootBloc mockRootBloc;
  MockStudentRepository mockStudentRepository;
  MockBorrowedItemRepository mockBorrowedItemRepository;

  setUp(() {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockRootBloc = MockRootBloc();
    mockItemRepository = MockItemRepository();
    mockStudentRepository = MockStudentRepository();
    mockBorrowedItemRepository = MockBorrowedItemRepository();
  });

  group('Item Return Bloc', () {
    blocTest<ItemReturnBloc, ItemReturnState>(
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

        when(
          () => mockBorrowedItemRepository.getBorrowedItemsByStudent(
            studentUUID: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => testBorrowedItemsList,
        );

        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(StudentIDScanEvent(scannedID: testStudent.indexNumber)),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false)),
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(true))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false))
            .having((state) => state.student, 'student', equals(testStudent))
            .having((state) => state.borrowedItems, 'borrowedItems',
                equals(testBorrowedItemsList)),
      ],
    );

    blocTest<ItemReturnBloc, ItemReturnState>(
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
          (_) async => testStudent,
        );

        when(
          () => mockBorrowedItemRepository.getBorrowedItemsByStudent(
            studentUUID: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(StudentIDScanEvent(scannedID: testStudent.indexNumber)),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false)),
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(true)),
      ],
    );

    blocTest<ItemReturnBloc, ItemReturnState>(
      'when \'ScanAndAcceptItemEvent\' successful,\'itemAcceptanceSuccess\' field of state should be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.acceptReturningItem(
            itemID: scannedItemID,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );

        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(ScanAndAcceptItemEvent(scannedItemID: scannedItemID)),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.itemAcceptanceSuccess,
                'itemAcceptanceSuccess', equals(false))
            .having((state) => state.itemAcceptanceError, 'itemAcceptanceError',
                equals(false)),
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.itemAcceptanceSuccess,
                'itemAcceptanceSuccess', equals(true))
            .having((state) => state.itemAcceptanceError, 'itemAcceptanceError',
                equals(false))
            .having(
                (state) => state.borrowedItems, 'borrowedItems', equals([])),
      ],
    );
    blocTest<ItemReturnBloc, ItemReturnState>(
      'when \'ScanAndAcceptItemEvent\' error,\'itemAcceptanceError\' field of state should be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.acceptReturningItem(
            itemID: scannedItemID,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(ScanAndAcceptItemEvent(scannedItemID: scannedItemID)),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.itemAcceptanceSuccess,
                'itemAcceptanceSuccess', equals(false))
            .having((state) => state.itemAcceptanceError, 'itemAcceptanceError',
                equals(false)),
        isA<ItemReturnState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.itemAcceptanceSuccess,
                'itemAcceptanceSuccess', equals(false))
            .having((state) => state.itemAcceptanceError, 'itemAcceptanceError',
                equals(true))
            .having((state) => state.borrowedItems, 'borrowedItems',
                equals(testBorrowedItemsList)),
      ],
    );

    blocTest<ItemReturnBloc, ItemReturnState>(
      'when \'ResetStateEvent\' state should be reset to initial state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );

        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        bloc.emit(studentIDScannedState);
        return bloc;
      },
      act: (bloc) => bloc.add(ResetStateEvent()),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.error, 'error', equals(""))
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.student, 'student', equals(null))
            .having((state) => state.borrowedItems, 'borrowedItems', equals([]))
            .having((state) => state.studentSearchSuccess,
                'studentSearchSuccess', equals(false))
            .having((state) => state.studentSearchError, 'studentSearchError',
                equals(false))
            .having((state) => state.itemAcceptanceSuccess,
                'itemAcceptanceSuccess', equals(false))
            .having((state) => state.itemAcceptanceError, 'itemAcceptanceError',
                equals(false)),
      ],
    );

    blocTest<ItemReturnBloc, ItemReturnState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        ItemReturnBloc bloc = ItemReturnBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockBorrowedItemRepository,
        );
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<ItemReturnState>()
            .having((state) => state.error, 'error', equals("")),
        isA<ItemReturnState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

const String scannedItemID = "RteF4563";
List<BorrowedItem> testBorrowedItemsList = [
  BorrowedItem(
      id: 'RteF4563',
      state: 'Borrowed',
      dueDate: '2023-10-03',
      displayItemImageURL: null,
      displayItemName: "Test Name"),
];
ItemReturnState studentIDScannedState = ItemReturnState(
  error: "",
  loading: false,
  studentSearchSuccess: false,
  studentSearchError: false,
  itemAcceptanceSuccess: false,
  itemAcceptanceError: false,
  student: testStudent,
  borrowedItems: testBorrowedItemsList,
);
