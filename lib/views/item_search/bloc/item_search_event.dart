import 'package:flutter/material.dart';

@immutable
abstract class ItemSearchEvent {}

class ErrorEvent extends ItemSearchEvent {
  final String error;

  ErrorEvent(this.error);
}

class SearchItemWithBarCodeEvent extends ItemSearchEvent {
  final String barcode;

  SearchItemWithBarCodeEvent({this.barcode});
}

class ClearItemEvent extends ItemSearchEvent {}

class DeleteItemEvent extends ItemSearchEvent {}
