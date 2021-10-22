import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'test_data/item.dart';
import 'test_data/logged_in_root_state.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockBuildContext extends Mock implements BuildContext {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockItemRepository mockItemRepository;
  MockBuildContext mockContext;
  MockRootBloc mockRootBloc;

  setUp(() {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    mockRootBloc = MockRootBloc();
    mockItemRepository = MockItemRepository();
  });

  group('Item Search Bloc', () {
    // 1. Item Search Event Success Test
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'SearchItemWithBarCodeEvent\' successful, item should be set to \'item\' field of state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.getFromAPI(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => testItem,
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(SearchItemWithBarCodeEvent(barcode: testItem.id)),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.searchError, 'searchError', equals(false)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.item, 'item', equals(testItem))
            .having((state) => state.searchError, 'searchError', equals(false)),
      ],
    );
    // 2. Item Search Event Fail Test
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'SearchItemWithBarCodeEvent\' fails, \'searchError\' field should be set to true in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.getFromAPI(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(SearchItemWithBarCodeEvent(barcode: testItem.id)),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.searchError, 'searchError', equals(false)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.searchError, 'searchError', equals(true))
            .having((state) => state.item, 'item', equals(null)),
      ],
    );

    // 3. Change Item State Event Success
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'ChangeItemStateEvent\' event successful, \'stateChangeSuccess\' should be set to true in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.changeItemState(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
            state: "Borrowed",
          ),
        ).thenAnswer(
          (_) async => null,
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);

        bloc.emit(itemSearchCompleteState);

        return bloc;
      },
      act: (bloc) => bloc.add(ChangeItemStateEvent(newState: "Borrowed")),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.stateChangeError, 'stateChangeError',
                equals(false))
            .having((state) => state.stateChangeSuccess, 'stateChangeSuccess',
                equals(false))
            .having((state) => state.item, 'item', equals(testItem)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.stateChangeError, 'stateChangeError',
                equals(false))
            .having((state) => state.stateChangeSuccess, 'stateChangeSuccess',
                equals(true)),
      ],
    );

    // 4. Change Item State Event Fail
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'ChangeItemStateEvent\' event fail, \'stateChangeError\' should be set to true in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.changeItemState(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
            state: "Borrowed",
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);

        bloc.emit(itemSearchCompleteState);

        return bloc;
      },
      act: (bloc) => bloc.add(ChangeItemStateEvent(newState: "Borrowed")),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.stateChangeError, 'stateChangeError',
                equals(false))
            .having((state) => state.stateChangeSuccess, 'stateChangeSuccess',
                equals(false))
            .having((state) => state.item, 'item', equals(testItem)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.stateChangeSuccess, 'stateChangeSuccess',
                equals(false))
            .having((state) => state.stateChangeError, 'stateChangeError',
                equals(true)),
      ],
    );

    // 5. Delete Item Event Success
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'DeleteItemEvent\' event successful, \'deletionSuccess\' should be set to true in state and \'item\' should be cleared from state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.deleteItem(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => null,
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);

        bloc.emit(itemSearchCompleteState);

        return bloc;
      },
      act: (bloc) => bloc.add(DeleteItemEvent()),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.deleteError, 'deleteError', equals(false))
            .having((state) => state.deletionSuccess, 'deletionSuccess',
                equals(false))
            .having((state) => state.item, 'item', equals(testItem)),
        isA<ItemSearchState>()
            .having((state) => state.item, 'item', equals(null)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.deleteError, 'deleteError', equals(false))
            .having((state) => state.deletionSuccess, 'deletionSuccess',
                equals(true)),
      ],
    );

    // 6. Delete Item Event Error
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'DeleteItemEvent\' event error, \'deletionError\' should be set to true in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.deleteItem(
            itemID: testItem.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);

        bloc.emit(itemSearchCompleteState);

        return bloc;
      },
      act: (bloc) => bloc.add(DeleteItemEvent()),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.deleteError, 'deleteError', equals(false))
            .having((state) => state.deletionSuccess, 'deletionSuccess',
                equals(false))
            .having((state) => state.item, 'item', equals(testItem)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.deleteError, 'deleteError', equals(true))
            .having((state) => state.deletionSuccess, 'deletionSuccess',
                equals(false)),
      ],
    );

    // 7. Clear Item State Event
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'ClearItemEvent\', state should be set to initial state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ClearItemEvent()),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.error, 'error', equals(""))
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.searchError, 'searchError', equals(false))
            .having((state) => state.deleteError, 'deleteError', equals(false))
            .having((state) => state.deletionSuccess, 'deletionSuccess',
                equals(false))
            .having((state) => state.stateChangeSuccess, 'stateChangeSuccess',
                equals(false))
            .having((state) => state.stateChangeError, 'stateChangeError',
                equals(false))
            .having((state) => state.item, 'item', equals(null))
      ],
    );

    //8. Error Event
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when \'ErrorEvent\', state \'error\' should be set in state',
      build: () {
        whenListen(
          mockRootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, mockRootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) => bloc.add(ErrorEvent("Error String")),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.error, 'error', equals("")),
        isA<ItemSearchState>()
            .having((state) => state.error, 'error', equals("Error String")),
      ],
    );
  });
}

ItemSearchState itemSearchCompleteState = ItemSearchState(
  error: "",
  loading: false,
  searchError: false,
  deleteError: false,
  deletionSuccess: false,
  stateChangeSuccess: false,
  stateChangeError: false,
  item: testItem,
);
