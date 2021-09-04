import 'package:flutter/material.dart';

@immutable
abstract class HandoverEvent {}

class ErrorEvent extends HandoverEvent {
  final String error;

  ErrorEvent(this.error);
}

class SearchStudentAndApprovedItemsEvent extends HandoverEvent {
  final String studentID;

  SearchStudentAndApprovedItemsEvent({this.studentID});
}

class ScanAndHandoverItemEvent extends HandoverEvent {
  final String scannedItemID;

  ScanAndHandoverItemEvent({this.scannedItemID});
}

class ClearStateEvent extends HandoverEvent {}
