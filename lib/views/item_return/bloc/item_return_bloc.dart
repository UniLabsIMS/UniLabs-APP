import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/classes/repository/borrowed_item_repository.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';

import 'item_return_event.dart';
import 'item_return_state.dart';

class ItemReturnBloc extends Bloc<ItemReturnEvent, ItemReturnState> {
  RootBloc rootBloc;
  StudentRepository studentRepository;
  ItemRepository itemRepository;
  BorrowedItemRepository borrowedItemRepository;
  Student studentObject = new Student();
  ItemReturnBloc(
      BuildContext context,
      RootBloc rootBloc,
      StudentRepository studentRepository,
      ItemRepository itemRepository,
      BorrowedItemRepository borrowedItemRepository)
      : super(ItemReturnState.initialState) {
    this.itemRepository = itemRepository;
    this.studentRepository = studentRepository;
    this.borrowedItemRepository = borrowedItemRepository;
    this.rootBloc = rootBloc;
  }

  @override
  Stream<ItemReturnState> mapEventToState(ItemReturnEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case StudentIDScanEvent:
        yield state.clone(
          loading: true,
          studentSearchSuccess: false,
          studentSearchError: false,
        );
        final scannedID = (event as StudentIDScanEvent).scannedID;
        try {
          // Search for student
          Student student = await studentRepository.getFromAPI(
            studentID: scannedID,
            token: rootBloc.state.user.token,
          );
          // Get borrowed items by student
          List<BorrowedItem> borrowedItems =
              await borrowedItemRepository.getBorrowedItemsByStudent(
            studentUUID: student.id,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            studentSearchSuccess: true,
            studentSearchError: false,
            student: student,
            borrowedItems: borrowedItems,
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            studentSearchSuccess: false,
            studentSearchError: true,
          );
        }
        break;
      case ScanAndAcceptItemEvent:
        yield state.clone(
          loading: true,
          itemAcceptanceSuccess: false,
          itemAcceptanceError: false,
        );
        final scannedID = (event as ScanAndAcceptItemEvent).scannedItemID;
        try {
          // Request to API to approve item
          await itemRepository.acceptReturningItem(
            itemID: scannedID,
            token: rootBloc.state.user.token,
          );
          // search for accepted items and remove it from borrowed items list
          List<BorrowedItem> updatedBorrowedItems = state.borrowedItems
              .where((item) => item.id != scannedID)
              .toList();
          yield state.clone(
            loading: false,
            itemAcceptanceSuccess: true,
            itemAcceptanceError: false,
            borrowedItems: updatedBorrowedItems,
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            itemAcceptanceSuccess: false,
            itemAcceptanceError: true,
          );
        }
        break;
      case ResetStateEvent:
        yield state.resetState();
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    _addErr(error);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    if (e is StateError) return;
    try {
      add(ErrorEvent((e is String)
          ? e
          : (e.message ?? "Something went wrong. Please try again!")));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again!"));
    }
  }
}
