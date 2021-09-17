import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';
import 'package:unilabs_app/classes/api/student.dart';

@immutable
class ItemReturnState {
  final String error;
  final bool loading;
  final bool studentSearchSuccess;
  final bool studentSearchError;
  final bool itemAcceptanceSuccess;
  final bool itemAcceptanceError;
  final Student student;
  final List<BorrowedItem> borrowedItems;

  ItemReturnState({
    @required this.error,
    @required this.loading,
    @required this.studentSearchSuccess,
    @required this.studentSearchError,
    @required this.itemAcceptanceSuccess,
    @required this.itemAcceptanceError,
    @required this.student,
    @required this.borrowedItems,
  });

  static ItemReturnState get initialState => ItemReturnState(
        error: '',
        loading: false,
        studentSearchSuccess: false,
        studentSearchError: false,
        itemAcceptanceSuccess: false,
        itemAcceptanceError: false,
        student: null,
        borrowedItems: [BorrowedItem(), BorrowedItem()],
      );

  ItemReturnState clone({
    String error,
    bool loading,
    bool studentSearchSuccess,
    bool studentSearchError,
    bool itemAcceptanceSuccess,
    bool itemAcceptanceError,
    Student student,
    List<BorrowedItem> borrowedItems,
  }) {
    return ItemReturnState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      studentSearchSuccess: studentSearchSuccess ?? this.studentSearchSuccess,
      studentSearchError: studentSearchError ?? this.studentSearchError,
      itemAcceptanceSuccess:
          itemAcceptanceSuccess ?? this.itemAcceptanceSuccess,
      itemAcceptanceError: itemAcceptanceError ?? this.itemAcceptanceError,
      student: student ?? this.student,
      borrowedItems: borrowedItems ?? this.borrowedItems,
    );
  }

  ItemReturnState resetState() {
    return ItemReturnState(
      error: '',
      loading: false,
      studentSearchSuccess: false,
      studentSearchError: false,
      itemAcceptanceSuccess: false,
      itemAcceptanceError: false,
      student: null,
      borrowedItems: [BorrowedItem(), BorrowedItem()],
    );
  }
}
