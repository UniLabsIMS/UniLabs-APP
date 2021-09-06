import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';

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
  final String selectedDisplayItemID;
  final List<ApprovedDisplayItem> approvedDisplayItemsList;
  final bool studentIDScanError;
  final bool itemScanError;
  final bool itemScanSuccess;

  HandoverState({
    @required this.error,
    @required this.step,
    @required this.loading,
    @required this.student,
    @required this.selectedDisplayItemID,
    @required this.approvedDisplayItemsList,
    @required this.studentIDScanError,
    @required this.itemScanError,
    @required this.itemScanSuccess,
  });

  static HandoverState get initialState => HandoverState(
        error: '',
        step: HandoverProcessStep.InitialStep,
        loading: false,
        student: null,
        selectedDisplayItemID: "",
        approvedDisplayItemsList: [],
        studentIDScanError: false,
        itemScanError: false,
        itemScanSuccess: false,
      );

  HandoverState clone({
    String error,
    HandoverProcessStep step,
    bool loading,
    Student student,
    String selectedDisplayItemID,
    List<ApprovedDisplayItem> approvedDisplayItemsList,
    bool studentIDScanError,
    bool itemScanError,
    bool itemScanSuccess,
  }) {
    return HandoverState(
      error: error ?? this.error,
      step: step ?? this.step,
      loading: loading ?? this.loading,
      student: student ?? this.student,
      selectedDisplayItemID:
          selectedDisplayItemID ?? this.selectedDisplayItemID,
      approvedDisplayItemsList:
          approvedDisplayItemsList ?? this.approvedDisplayItemsList,
      studentIDScanError: studentIDScanError ?? this.studentIDScanError,
      itemScanError: itemScanError ?? this.itemScanError,
      itemScanSuccess: itemScanSuccess ?? this.itemScanSuccess,
    );
  }

  HandoverState clearState() {
    return HandoverState(
      error: '',
      step: HandoverProcessStep.InitialStep,
      loading: false,
      student: null,
      selectedDisplayItemID: "",
      approvedDisplayItemsList: [],
      studentIDScanError: false,
      itemScanError: false,
      itemScanSuccess: false,
    );
  }
}
