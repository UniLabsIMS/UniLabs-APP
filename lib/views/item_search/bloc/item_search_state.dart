import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/item.dart';

@immutable
class ItemSearchState {
  final String error;
  final bool loading;
  final bool searchError;
  final bool deleteError;
  final bool deletionSuccess;
  final bool stateChangeSuccess;
  final bool stateChangeError;
  final Item item; //made a list to as we need to empty it

  ItemSearchState({
    @required this.error,
    @required this.loading,
    @required this.searchError,
    @required this.deleteError,
    @required this.deletionSuccess,
    @required this.stateChangeSuccess,
    @required this.stateChangeError,
    @required this.item,
  });

  static ItemSearchState get initialState => ItemSearchState(
        error: '',
        loading: false,
        searchError: false,
        deleteError: false,
        deletionSuccess: false,
        stateChangeSuccess: false,
        stateChangeError: false,
        item: null,
      );

  ItemSearchState clone({
    String error,
    bool loading,
    bool searchError,
    bool deleteError,
    bool deletionSuccess,
    bool stateChangeSuccess,
    bool stateChangeError,
    String barcode,
    Item item,
  }) {
    return ItemSearchState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      searchError: searchError ?? this.searchError,
      deleteError: deleteError ?? this.deleteError,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      stateChangeSuccess: stateChangeSuccess ?? this.stateChangeSuccess,
      stateChangeError: stateChangeError ?? this.stateChangeError,
      item: item ?? this.item,
    );
  }

  ItemSearchState clearItem() {
    return ItemSearchState(
      error: '',
      loading: false,
      searchError: false,
      deleteError: false,
      deletionSuccess: false,
      stateChangeSuccess: false,
      stateChangeError: false,
      item: null,
    );
  }
}
