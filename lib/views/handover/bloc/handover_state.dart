import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';

@immutable
class HandoverState {
  final String error;
  final bool loading;
  final Student student;
  final List<ApprovedDisplayItem> approvedDisplayItemsList;
  final bool studentIDScanError;
  final bool itemScanError;
  final bool itemScanSuccess;

  HandoverState({
    @required this.error,
    @required this.loading,
    @required this.student,
    @required this.approvedDisplayItemsList,
    @required this.studentIDScanError,
    @required this.itemScanError,
    @required this.itemScanSuccess,
  });

  static HandoverState get initialState => HandoverState(
        error: '',
        loading: false,
        student: null,
        approvedDisplayItemsList: [],
        studentIDScanError: false,
        itemScanError: false,
        itemScanSuccess: false,
      );

  HandoverState clone({
    String error,
    bool loading,
    Student student,
    List<ApprovedDisplayItem> approvedDisplayItemsList,
    bool studentIDScanError,
    bool itemScanError,
    bool itemScanSuccess,
  }) {
    return HandoverState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      student: student ?? this.student,
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
      loading: false,
      student: null,
      approvedDisplayItemsList: [],
      studentIDScanError: false,
      itemScanError: false,
      itemScanSuccess: false,
    );
  }
}
