import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/classes/utils.dart';

enum HandoverProcessStep {
  InitialStep,
  ItemScanStep,
}

@immutable
class HandoverState {
  final String error;
  final HandoverProcessStep step;
  final bool loading;
  final Student student;
  final ApprovedDisplayItem selectedApprovedDisplayItem;
  final List<ApprovedDisplayItem> approvedDisplayItemsList;
  final bool studentIDScanError;
  final bool itemScanError;
  final bool itemScanSuccess;
  final bool clearAllApprovedSuccess;
  final bool clearAllApprovedError;
  final String dueDate;

  HandoverState({
    @required this.error,
    @required this.step,
    @required this.loading,
    @required this.student,
    @required this.selectedApprovedDisplayItem,
    @required this.approvedDisplayItemsList,
    @required this.studentIDScanError,
    @required this.itemScanError,
    @required this.itemScanSuccess,
    @required this.clearAllApprovedSuccess,
    @required this.clearAllApprovedError,
    @required this.dueDate,
  });

  static HandoverState get initialState => HandoverState(
        error: '',
        step: HandoverProcessStep.InitialStep,
        loading: false,
        student: null,
        selectedApprovedDisplayItem: null,
        approvedDisplayItemsList: [],
        studentIDScanError: false,
        itemScanError: false,
        itemScanSuccess: false,
        clearAllApprovedSuccess: false,
        clearAllApprovedError: false,
        dueDate: Util.setInitialDueDate(),
      );

  HandoverState clone({
    String error,
    HandoverProcessStep step,
    bool loading,
    Student student,
    String selectedDisplayItemID,
    String selectedApprovedItemID,
    ApprovedDisplayItem selectedApprovedDisplayItem,
    List<ApprovedDisplayItem> approvedDisplayItemsList,
    bool studentIDScanError,
    bool itemScanError,
    bool itemScanSuccess,
    bool clearAllApprovedSuccess,
    bool clearAllApprovedError,
    String dueDate,
  }) {
    return HandoverState(
      error: error ?? this.error,
      step: step ?? this.step,
      loading: loading ?? this.loading,
      student: student ?? this.student,
      selectedApprovedDisplayItem:
          selectedApprovedDisplayItem ?? this.selectedApprovedDisplayItem,
      approvedDisplayItemsList:
          approvedDisplayItemsList ?? this.approvedDisplayItemsList,
      studentIDScanError: studentIDScanError ?? this.studentIDScanError,
      itemScanError: itemScanError ?? this.itemScanError,
      itemScanSuccess: itemScanSuccess ?? this.itemScanSuccess,
      clearAllApprovedSuccess:
          clearAllApprovedSuccess ?? this.clearAllApprovedSuccess,
      clearAllApprovedError:
          clearAllApprovedError ?? this.clearAllApprovedError,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  HandoverState clearState() {
    return HandoverState(
      error: '',
      step: HandoverProcessStep.InitialStep,
      loading: false,
      student: null,
      selectedApprovedDisplayItem: null,
      approvedDisplayItemsList: [],
      studentIDScanError: false,
      itemScanError: false,
      itemScanSuccess: false,
      clearAllApprovedSuccess: false,
      clearAllApprovedError: false,
      dueDate: Util.setInitialDueDate(),
    );
  }
}
