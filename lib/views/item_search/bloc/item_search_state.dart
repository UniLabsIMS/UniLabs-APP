import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/item.dart';

@immutable
class ItemSearchState {
  final String error;
  final bool loading;
  final bool searchError;
  final Item item; //made a list to as we need to empty it

  ItemSearchState({
    @required this.error,
    @required this.loading,
    @required this.searchError,
    @required this.item,
  });

  static ItemSearchState get initialState => ItemSearchState(
        error: '',
        loading: false,
        searchError: false,
        item: null,
      );

  ItemSearchState clone({
    String error,
    bool loading,
    bool searchError,
    String barcode,
    Item item,
  }) {
    return ItemSearchState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      searchError: searchError ?? this.searchError,
      item: item ?? this.item,
    );
  }
}
