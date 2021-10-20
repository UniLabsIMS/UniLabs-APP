// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:unilabs_app/classes/api/item.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:unilabs_app/classes/api/user.dart';
// import 'package:unilabs_app/root_bloc/root_bloc.dart';
// import 'package:unilabs_app/root_bloc/root_event.dart';
// import 'package:unilabs_app/root_bloc/root_state.dart';
// import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
// import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
// import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
//
// class MockItem extends Mock implements Item {}
//
// class MockBuildContext extends Mock implements BuildContext {}
//
// class MockRootBloc extends MockBloc<RootEvent, RootState> implements RootBloc {}
//
// class FakeRootEvent extends Fake implements RootEvent {}
//
// class FakeRootState extends Fake implements RootState {}
//
// void main() {
//   MockItem item;
//   MockBuildContext _mockContext;
//   MockRootBloc rootBloc;
//
//   setUp(() {
//     _mockContext = MockBuildContext();
//     registerFallbackValue<RootEvent>(FakeRootEvent());
//     registerFallbackValue<RootState>(FakeRootState());
//     rootBloc = MockRootBloc();
//     item = MockItem();
//   });
//
//   group('Item Search Bloc', () {
//     // Student student = new Student(
//     //   id: "6d3716ae-e864-4958-aee3-7833b889915f",
//     //   indexNumber: "180594V",
//     //   email: "avishka@gmail.com",
//     //   firstName: "Avishka",
//     //   lastName: "Shamendra",
//     //   imageURL: null,
//     //   departmentName: "Computer Science and Engineering",
//     //   departmentCode: "CSE",
//     //   contactNo: "0777567456",
//     // );
//     Item responseItem = new Item(
//       id: "69ef8391",
//       state: "Borrowed",
//       parentDisplayItemName: "Arduino Uno",
//       parentDisplayItemDescription: "Micro controller for projects",
//       parentDisplayItemImageURL: null,
//       categoryName: "Micro Controllers",
//       labName: "Embedded Systems Laboratory",
//     );
//
//     blocTest<ItemSearchBloc, ItemSearchState>(
//       'emits [WeatherLoading, WeatherLoaded] when successful',
//       build: () {
//         whenListen(
//             rootBloc,
//             Stream.fromIterable([
//               RootState(
//                   error: "",
//                   user: User(id: "1", token: "2"),
//                   loginState: LoginStateType.LOGIN,
//                   checkStarted: false)
//             ]),
//             initialState: RootState(
//                 error: "",
//                 user: User(id: "1", token: "2"),
//                 loginState: LoginStateType.LOGIN,
//                 checkStarted: false));
//         when(() => item.getFromAPI(itemID: responseItem.id, token: "2"))
//             .thenAnswer((_) async => responseItem);
//
//         ItemSearchBloc bloc = ItemSearchBloc(_mockContext, rootBloc, item);
//         return bloc;
//       },
//       act: (bloc) =>
//           bloc.add(SearchItemWithBarCodeEvent(barcode: responseItem.id)),
//       expect: () => [
//         isA<ItemSearchState>()
//             .having((state) => state.loading, 'loading', equals(true)),
//         isA<ItemSearchState>()
//             .having((state) => state.item, 'item', equals(responseItem)),
//       ],
//     );
//   });
// }
