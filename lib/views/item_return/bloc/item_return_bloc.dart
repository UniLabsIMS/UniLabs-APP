import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';
import 'package:unilabs_app/classes/api/student.dart';

import 'item_return_event.dart';
import 'item_return_state.dart';

class ItemReturnBloc extends Bloc<ItemReturnEvent, ItemReturnState> {
  ItemReturnBloc(BuildContext context) : super(ItemReturnState.initialState);

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
          //TODO: Request to API to search student
          await Future.delayed(const Duration(seconds: 2));
          yield state.clone(
            loading: false,
            studentSearchSuccess: true,
            studentSearchError: false,
            student: new Student(),
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
          //TODO: Request to API to approve item
          await Future.delayed(const Duration(seconds: 2), () {});
          // TODO: search for accepted items and remove it from borrowed items list
          List<BorrowedItem> updatedBorrowedItems =
              List.from(state.borrowedItems);
          updatedBorrowedItems.removeAt(0);
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
