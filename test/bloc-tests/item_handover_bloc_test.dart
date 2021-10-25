import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/repository/approved_display_item_repository.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'test_data/logged_in_root_state.dart';
import 'test_data/student.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockStudentRepository extends Mock implements StudentRepository {}

class MockApprovedDisplayItemRepository extends Mock
    implements ApprovedDisplayItemRepository {}

class MockBuildContext extends Mock implements BuildContext {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockItemRepository mockItemRepository;
  MockBuildContext mockContext;
  MockRootBloc mockRootBloc;
  MockStudentRepository mockStudentRepository;
  ApprovedDisplayItemRepository mockApprovedDisplayItemRepository;

  setUp(() {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockRootBloc = MockRootBloc();
    mockItemRepository = MockItemRepository();
    mockStudentRepository = MockStudentRepository();
    mockApprovedDisplayItemRepository = MockApprovedDisplayItemRepository();
  });

  group('Temporary Handover Bloc', () {
    blocTest<HandoverBloc, HandoverState>(
      'when \'SearchStudentAndApprovedItemsEvent\' successful, student object should be set to \'student\' field of state and \'approvedDisplayItemsList\' must be filled.',
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
          () => mockApprovedDisplayItemRepository.getApprovedItemsFromAPI(
            labId: loggedInRootState.user.labId,
            studentId: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => approvedDisplayItemList,
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        return bloc;
      },
      act: (bloc) => bloc.add(SearchStudentAndApprovedItemsEvent(
          studentID: testStudent.indexNumber)),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentIDScanError, 'studentIDScanError',
                equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentIDScanError, 'studentSearchError',
                equals(false))
            .having((state) => state.student, 'student', equals(testStudent))
            .having((state) => state.approvedDisplayItemsList,
                'approvedDisplayItemsList', equals(approvedDisplayItemList)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'SearchStudentAndApprovedItemsEvent\' error,\'studentIDScanError\' field of state must be set to true.',
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
          () => mockApprovedDisplayItemRepository.getApprovedItemsFromAPI(
            labId: loggedInRootState.user.labId,
            studentId: testStudent.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        SearchStudentAndApprovedItemsEvent(
          studentID: testStudent.indexNumber,
        ),
      ),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.studentIDScanError, 'studentIDScanError',
                equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.studentIDScanError, 'studentSearchError',
                equals(true)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'SelectDisplayItemToScanItemsEvent\', \'selectedApprovedDisplayItem\' field of state is set to selected item.',
      build: () {
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(
        SelectDisplayItemToScanItemsEvent(
          approvedDisplayItem: testApprovedDisplayItem,
        ),
      ),
      expect: () => [
        isA<HandoverState>().having(
          (state) => state.selectedApprovedDisplayItem,
          'selectedApprovedDisplayItem',
          equals(
            testApprovedDisplayItem,
          ),
        ),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ChangeHandoverStepEvent\', state \'step\' should be set with passed step',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );

        return bloc;
      },
      act: (bloc) => bloc.add(
          ChangeHandoverStepEvent(nextStep: HandoverProcessStep.ItemScanStep)),
      expect: () => [
        isA<HandoverState>().having((state) => state.step, 'step',
            equals(HandoverProcessStep.ItemScanStep)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ClearSelectedDisplayItemEvent\', \'selectedApprovedDisplayItem\' field of state should be set to null.',
      build: () {
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(ClearSelectedDisplayItemEvent()),
      expect: () => [
        isA<HandoverState>().having(
          (state) => state.selectedApprovedDisplayItem,
          'selectedApprovedDisplayItem',
          equals(null),
        ),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'UpdateDueDateEvent\', \'dueDate\' field of state should be set to passed date.',
      build: () {
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateDueDateEvent(dateString: '2021-10-01')),
      expect: () => [
        isA<HandoverState>().having(
          (state) => state.dueDate,
          'dueDate',
          equals('2021-10-01'),
        ),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'HandoverScannedItemEvent\' successful,  \'itemScanSuccess\' field of state must be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.approvedItemHandover(
            itemID: scannedItemID,
            dueDate: itemScanBarcodeStepInitialState.dueDate,
            approvalId: approvedDisplayItemList[0].id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(HandoverScannedItemEvent(
        scannedItemID: scannedItemID,
      )),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having(
                (state) => state.itemScanError, 'itemScanError', equals(false))
            .having((state) => state.itemScanSuccess, 'itemScanSuccess',
                equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having(
                (state) => state.itemScanError, 'itemScanError', equals(false))
            .having((state) => state.itemScanSuccess, 'itemScanSuccess',
                equals(true))
            .having((state) => state.approvedDisplayItemsList,
                'approvedDisplayItemsList', equals(approvedDisplayItemList)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'HandoverScannedItemEvent\' error,  \'itemScanError\' field of state must be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.approvedItemHandover(
            itemID: scannedItemID,
            dueDate: itemScanBarcodeStepInitialState.dueDate,
            approvalId: approvedDisplayItemList[0].id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(HandoverScannedItemEvent(
        scannedItemID: scannedItemID,
      )),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having(
                (state) => state.itemScanError, 'itemScanError', equals(false))
            .having((state) => state.itemScanSuccess, 'itemScanSuccess',
                equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having(
                (state) => state.itemScanError, 'itemScanError', equals(true))
            .having((state) => state.itemScanSuccess, 'itemScanSuccess',
                equals(false))
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ClearAllApprovedDisplayItemsEvent\' successful,  \'approvedDisplayItemsList\' field of state must be cleared.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockApprovedDisplayItemRepository.clearAllApprovedItemsFromAPI(
            labId: loggedInRootState.user.labId,
            studentId: itemScanBarcodeStepInitialState.student.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(ClearAllApprovedDisplayItemsEvent()),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.clearAllApprovedSuccess,
                'clearAllApprovedSuccess', equals(false))
            .having((state) => state.clearAllApprovedError,
                'clearAllApprovedError', equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.approvedDisplayItemsList,
                'approvedDisplayItemsList', equals([]))
            .having((state) => state.clearAllApprovedError,
                'clearAllApprovedError', equals(false))
            .having((state) => state.clearAllApprovedSuccess,
                'clearAllApprovedSuccess', equals(true)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ClearAllApprovedDisplayItemsEvent\' error,  \'clearAllApprovedError\' field of state must be set to true.',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockApprovedDisplayItemRepository.clearAllApprovedItemsFromAPI(
            labId: loggedInRootState.user.labId,
            studentId: itemScanBarcodeStepInitialState.student.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(ClearAllApprovedDisplayItemsEvent()),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.clearAllApprovedSuccess,
                'clearAllApprovedSuccess', equals(false))
            .having((state) => state.clearAllApprovedError,
                'clearAllApprovedError', equals(false)),
        isA<HandoverState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.clearAllApprovedError,
                'clearAllApprovedError', equals(true))
            .having((state) => state.clearAllApprovedSuccess,
                'clearAllApprovedSuccess', equals(false)),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ClearStateEvent\', state should be set to initial state.',
      build: () {
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );
        bloc.emit(itemScanBarcodeStepInitialState);
        return bloc;
      },
      act: (bloc) => bloc.add(ClearStateEvent()),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.student, 'student', equals(null))
            .having((state) => state.approvedDisplayItemsList,
                'approvedDisplayItemsList', equals([])),
      ],
    );

    blocTest<HandoverBloc, HandoverState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        HandoverBloc bloc = HandoverBloc(
          mockContext,
          mockRootBloc,
          mockStudentRepository,
          mockItemRepository,
          mockApprovedDisplayItemRepository,
        );

        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<HandoverState>()
            .having((state) => state.error, 'error', equals("")),
        isA<HandoverState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

const String scannedItemID = "RteF4563";
HandoverState itemScanBarcodeStepInitialState = HandoverState(
  error: "",
  step: HandoverProcessStep.ItemScanStep,
  loading: false,
  student: testStudent,
  approvedDisplayItemsList: approvedDisplayItemList,
  selectedApprovedDisplayItem: testApprovedDisplayItem,
  clearAllApprovedError: false,
  itemScanSuccess: false,
  studentIDScanError: false,
  itemScanError: false,
  dueDate: '2024-10-31',
  clearAllApprovedSuccess: false,
);

ApprovedDisplayItem testApprovedDisplayItem = ApprovedDisplayItem(
  id: '867dd9e7f8d3eb6977d721ff44fcaedbbad9d33c74f66ef20be1474cf000422a',
  displayItemName: "Test Name",
  displayItemDescription: "Description.....",
  displayItemId:
      "254dd9e9f8d3eb6927d721ff74fcaedbbad9d33c54f66ef20be1474cf000422a",
  displayItemImageURL: null,
  requestedItemCount: 4,
);
List<ApprovedDisplayItem> approvedDisplayItemList = [
  testApprovedDisplayItem,
];
