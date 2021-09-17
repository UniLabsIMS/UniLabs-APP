import 'package:flutter/material.dart';

@immutable
abstract class ItemReturnEvent {}

class ErrorEvent extends ItemReturnEvent {
  final String error;

  ErrorEvent(this.error);
}

class StudentIDScanEvent extends ItemReturnEvent {
  final String scannedID;

  StudentIDScanEvent({this.scannedID});
}

class ScanAndAcceptItemEvent extends ItemReturnEvent {
  final String scannedItemID;

  ScanAndAcceptItemEvent({this.scannedItemID});
}

class ResetStateEvent extends ItemReturnEvent {}
