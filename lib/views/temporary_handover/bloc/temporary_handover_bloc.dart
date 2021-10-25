import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';

import 'temporary_handover_event.dart';
import 'temporary_handover_state.dart';

class TemporaryHandoverBloc
    extends Bloc<TemporaryHandoverEvent, TemporaryHandoverState> {
  RootBloc rootBloc;
  StudentRepository studentRepository;
  ItemRepository itemRepository;
  TemporaryHandoverBloc(BuildContext context, RootBloc rootBloc,
      StudentRepository studentRepository, ItemRepository itemRepository)
      : super(TemporaryHandoverState.initialState) {
    this.itemRepository = itemRepository;
    this.studentRepository = studentRepository;
    this.rootBloc = rootBloc;
  }

  @override
  Stream<TemporaryHandoverState> mapEventToState(
      TemporaryHandoverEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case StudentIDScanEvent:
        yield state.clone(
          loading: true,
          studentSearchSuccess: false,
          studentSearchError: false,
        );
        final scannedID = (event as StudentIDScanEvent).scannedID;
        try {
          Student student = await studentRepository.getFromAPI(
            studentID: scannedID,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            studentSearchSuccess: true,
            studentSearchError: false,
            student: student,
          );
        } on DioError {
          yield state.clone(
            loading: false,
            studentSearchSuccess: false,
            studentSearchError: true,
          );
        }
        break;
      case ScanAndTempHandoverItemEvent:
        yield state.clone(
          loading: true,
          handoverSuccess: false,
          handoverError: false,
        );
        final scannedID = (event as ScanAndTempHandoverItemEvent).scannedID;
        try {
          await itemRepository.tempHandover(
            itemID: scannedID,
            studentUUID: state.student.id,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            handoverSuccess: true,
            handoverError: false,
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            handoverSuccess: false,
            handoverError: true,
          );
        }
        break;
      case ResetStateEvent:
        yield state.resetState();
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    _addErr(error);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    if (e is StateError) return;
    try {
      add(ErrorEvent((e is String)
          ? e
          : (e.message ?? "Something went wrong. Please try again!")));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again!"));
    }
  }
}
