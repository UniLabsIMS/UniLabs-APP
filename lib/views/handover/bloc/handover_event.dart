import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';

@immutable
abstract class HandoverEvent {}

class ErrorEvent extends HandoverEvent {
  final String error;

  ErrorEvent(this.error);
}

class ChangeHandoverStepEvent extends HandoverEvent {
  final HandoverProcessStep nextStep;

  ChangeHandoverStepEvent({this.nextStep});
}

class SearchStudentAndApprovedItemsEvent extends HandoverEvent {
  final String studentID;

  SearchStudentAndApprovedItemsEvent({this.studentID});
}

class HandoverScannedItemEvent extends HandoverEvent {
  final String scannedItemID;

  HandoverScannedItemEvent({this.scannedItemID});
}

class ClearStateEvent extends HandoverEvent {}

class SelectDisplayItemToScanItemsEvent extends HandoverEvent {
  final ApprovedDisplayItem approvedDisplayItem;

  SelectDisplayItemToScanItemsEvent({
    this.approvedDisplayItem,
  });
}

class UpdateDueDateEvent extends HandoverEvent {
  final String dateString;
  UpdateDueDateEvent({this.dateString});
}

class ClearSelectedDisplayItemEvent extends HandoverEvent {}

class ClearAllApprovedDisplayItemsEvent extends HandoverEvent {}
