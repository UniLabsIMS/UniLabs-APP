import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/student.dart';

import 'handover_event.dart';
import 'handover_state.dart';

class HandoverBloc extends Bloc<HandoverEvent, HandoverState> {
  HandoverBloc(BuildContext context) : super(HandoverState.initialState);

  @override
  Stream<HandoverState> mapEventToState(HandoverEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case ChangeHandoverStepEvent:
        HandoverProcessStep nextStep =
            (event as ChangeHandoverStepEvent).nextStep;
        yield state.clone(step: nextStep);
        break;
      case SearchStudentAndApprovedItemsEvent:
        yield state.clone(
          loading: true,
          studentIDScanError: false,
        );
        String studentID =
            (event as SearchStudentAndApprovedItemsEvent).studentID;
        try {
          //  TODO: Request to API to search for approved Items
          await Future.delayed(const Duration(seconds: 2), () {});
          yield state.clone(
            loading: false,
            studentIDScanError: false,
            student: new Student(),
            approvedDisplayItemsList: [],
          );
        } catch (e) {
          yield state.clone(loading: false, studentIDScanError: true);
        }
        break;
      case HandoverScannedItemEvent:
        yield state.clone(
            loading: true, itemScanError: false, itemScanSuccess: false);
        String scannedItemID =
            (event as HandoverScannedItemEvent).scannedItemID;
        try {
          //  TODO: Request to API to search and handover the item and decrease requested quantity displayed by 1
          await Future.delayed(const Duration(seconds: 2), () {});
          yield state.clone(
            loading: false,
            itemScanError: false,
            itemScanSuccess: true,
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            itemScanError: true,
            itemScanSuccess: false,
          );
        }
        break;
      case ClearStateEvent:
        yield state.clearState();
        break;
      case SelectDisplayItemToScanItemsEvent:
        String displayItemId =
            (event as SelectDisplayItemToScanItemsEvent).displayItemId;
        state.clone(selectedDisplayItemID: displayItemId);
        break;
      case ClearSelectedDisplayItemEvent:
        state.clone(selectedDisplayItemID: "");
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
