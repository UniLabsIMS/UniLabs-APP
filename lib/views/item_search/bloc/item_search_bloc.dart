import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/item.dart';

import 'item_search_event.dart';
import 'item_search_state.dart';

class ItemSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc(BuildContext context) : super(ItemSearchState.initialState);

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case SearchItemWithBarCodeEvent:
        yield state.clone(loading: true, searchError: false);
        String barcode = (event as SearchItemWithBarCodeEvent).barcode;
        try {
          //TODO: Request to get data from API and create item object
          await Future.delayed(const Duration(seconds: 2), () {});
          yield state.clone(
            loading: false,
            searchError: false,
            item: new Item(),
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            searchError: true,
          );
        }
        break;
      case ClearItemEvent:
        yield state.clearItem();
        break;
      case DeleteItemEvent:
        yield state.clone(
            loading: true, deleteError: false, deletionSuccess: false);
        try {
          //TODO: Request to get delete item to API
          await Future.delayed(const Duration(seconds: 2), () {});
          yield state.clearItem();
          yield state.clone(
              loading: false, deleteError: false, deletionSuccess: true);
        } catch (e) {
          yield state.clone(
              loading: false, deleteError: true, deletionSuccess: false);
        }
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
