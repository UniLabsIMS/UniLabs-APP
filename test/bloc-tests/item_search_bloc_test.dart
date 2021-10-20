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
import 'test_data/item_search_reponse_data.dart';
import 'test_data/root_user_data.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockBuildContext extends Mock implements BuildContext {}

class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}

class FakeRootEvent extends Fake implements RootEvent {}

class FakeRootState extends Fake implements RootState {}

void main() {
  MockItemRepository mockItemRepository;
  MockBuildContext mockContext;
  MockRootBloc rootBloc;

  setUp(() {
    mockContext = MockBuildContext();
    registerFallbackValue<RootEvent>(FakeRootEvent());
    registerFallbackValue<RootState>(FakeRootState());
    rootBloc = MockRootBloc();
    mockItemRepository = MockItemRepository();
  });

  group('Item Search Bloc', () {
    blocTest<ItemSearchBloc, ItemSearchState>(
      'when search successful item field is set in state',
      build: () {
        whenListen(
          rootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.getFromAPI(
            itemID: itemSearchResponse.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => itemSearchResponse,
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, rootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(SearchItemWithBarCodeEvent(barcode: itemSearchResponse.id)),
      expect: () => [
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(true))
            .having((state) => state.searchError, 'searchError', equals(false)),
        isA<ItemSearchState>()
            .having((state) => state.loading, 'loading', equals(false))
            .having((state) => state.item, 'item', equals(itemSearchResponse))
            .having((state) => state.searchError, 'searchError', equals(false)),
      ],
    );

    blocTest<ItemSearchBloc, ItemSearchState>(
      'when search fails searchError field is set to true in state',
      build: () {
        whenListen(
          rootBloc,
          Stream.fromIterable([loggedInRootState]),
          initialState: loggedInRootState,
        );
        when(
          () => mockItemRepository.getFromAPI(
            itemID: itemSearchResponse.id,
            token: loggedInRootState.user.token,
          ),
        ).thenAnswer(
          (_) async => throw DioError(
            requestOptions: RequestOptions(path: "/"),
            type: DioErrorType.connectTimeout,
          ),
        );

        ItemSearchBloc bloc =
            ItemSearchBloc(mockContext, rootBloc, mockItemRepository);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(SearchItemWithBarCodeEvent(barcode: itemSearchResponse.id)),
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
  });
}
