import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/item.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';

import 'item_search_event.dart';
import 'item_search_state.dart';

class ItemSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {
  RootBloc rootBloc;
  ItemRepository itemRepository;
  ItemSearchBloc(
      BuildContext context, RootBloc rootBloc, ItemRepository itemRepository)
      : super(ItemSearchState.initialState) {
    this.rootBloc = rootBloc;
    this.itemRepository = itemRepository;
  }

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
          Item item = await itemRepository.getFromAPI(
            itemID: barcode,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            searchError: false,
            item: item,
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
          loading: true,
          deleteError: false,
          deletionSuccess: false,
        );
        try {
          await itemRepository.deleteItem(
            itemID: state.item.id,
            token: rootBloc.state.user.token,
          );
          yield state.clearItem();
          yield state.clone(
            loading: false,
            deleteError: false,
            deletionSuccess: true,
          );
        } on DioError {
          yield state.clone(
            loading: false,
            deleteError: true,
            deletionSuccess: false,
          );
        }
        break;
      case ChangeItemStateEvent:
        String newState = (event as ChangeItemStateEvent).newState;
        if (state.item.state != newState) {
          yield state.clone(
            loading: true,
            stateChangeError: false,
            stateChangeSuccess: false,
          );
          try {
            await itemRepository.changeItemState(
              itemID: state.item.id,
              state: newState,
              token: rootBloc.state.user.token,
            );
            Item item = state.item.clone();
            item.state = newState;
            yield state.clone(
              loading: false,
              stateChangeError: false,
              stateChangeSuccess: true,
              item: item,
            );
          } on DioError {
            yield state.clone(
              loading: false,
              stateChangeError: true,
              stateChangeSuccess: false,
            );
          }
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
