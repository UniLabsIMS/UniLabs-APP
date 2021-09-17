import 'package:flutter/material.dart';

@immutable
abstract class TemporaryHandoverEvent {}

class ErrorEvent extends TemporaryHandoverEvent {
  final String error;

  ErrorEvent(this.error);
}

class StudentIDScanEvent extends TemporaryHandoverEvent {
  final String scannedID;

  StudentIDScanEvent({this.scannedID});
}

class ScanAndTempHandoverItemEvent extends TemporaryHandoverEvent {
  final String scannedID;

  ScanAndTempHandoverItemEvent({this.scannedID});
}

class ResetStateEvent extends TemporaryHandoverEvent {}
