import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/student.dart';

@immutable
class TemporaryHandoverState {
  final String error;
  final bool loading;
  final bool studentSearchSuccess;
  final bool studentSearchError;
  final bool handoverSuccess;
  final bool handoverError;
  final Student student;

  TemporaryHandoverState({
    @required this.error,
    @required this.loading,
    @required this.studentSearchSuccess,
    @required this.studentSearchError,
    @required this.handoverSuccess,
    @required this.handoverError,
    @required this.student,
  });

  static TemporaryHandoverState get initialState => TemporaryHandoverState(
        error: '',
        loading: false,
        studentSearchSuccess: false,
        studentSearchError: false,
        handoverSuccess: false,
        handoverError: false,
        student: null,
      );

  TemporaryHandoverState clone({
    String error,
    bool loading,
    bool studentSearchSuccess,
    bool studentSearchError,
    bool handoverSuccess,
    bool handoverError,
    Student student,
  }) {
    return TemporaryHandoverState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      studentSearchSuccess: studentSearchSuccess ?? this.studentSearchSuccess,
      studentSearchError: studentSearchError ?? this.studentSearchError,
      handoverSuccess: handoverSuccess ?? this.handoverSuccess,
      handoverError: handoverError ?? this.handoverError,
      student: student ?? this.student,
    );
  }

  TemporaryHandoverState resetState() {
    return TemporaryHandoverState(
      error: '',
      loading: false,
      studentSearchSuccess: false,
      studentSearchError: false,
      handoverSuccess: false,
      handoverError: false,
      student: null,
    );
  }
}
