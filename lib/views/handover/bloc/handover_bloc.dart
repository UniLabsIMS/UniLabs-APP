import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/classes/api/student.dart';
import 'package:unilabs_app/classes/repository/approved_display_item_repository.dart';
import 'package:unilabs_app/classes/repository/item_repository.dart';
import 'package:unilabs_app/classes/repository/student_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';

import 'handover_event.dart';
import 'handover_state.dart';

class HandoverBloc extends Bloc<HandoverEvent, HandoverState> {
  RootBloc rootBloc;
  StudentRepository studentRepository;
  ItemRepository itemRepository;
  ApprovedDisplayItemRepository approvedDisplayItemRepository;
  HandoverBloc(
      BuildContext context,
      RootBloc rootBloc,
      StudentRepository studentRepository,
      ItemRepository itemRepository,
      ApprovedDisplayItemRepository approvedDisplayItemRepository)
      : super(HandoverState.initialState) {
    this.studentRepository = studentRepository;
    this.itemRepository = itemRepository;
    this.approvedDisplayItemRepository = approvedDisplayItemRepository;
    this.rootBloc = rootBloc;
  }

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
          //  Get student and approved items from API
          Student student = await studentRepository.getFromAPI(
            studentID: studentID,
            token: rootBloc.state.user.token,
          );
          List<ApprovedDisplayItem> approvedDisplayItems =
              await approvedDisplayItemRepository.getApprovedItemsFromAPI(
            labId: rootBloc.state.user.labId,
            studentId: student.id,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            studentIDScanError: false,
            student: student,
            approvedDisplayItemsList: approvedDisplayItems,
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
          //  Request to API to search and handover the item and decrease requested quantity displayed by 1
          await itemRepository.approvedItemHandover(
            itemID: scannedItemID,
            approvalId: state.selectedApprovedDisplayItem.id,
            dueDate: state.dueDate,
            token: rootBloc.state.user.token,
          );
          List<ApprovedDisplayItem> itemLst =
              List.from(state.approvedDisplayItemsList); //copy
          ApprovedDisplayItem updatedSelectedApprovedItem;
          for (int i = 0; i < itemLst.length; i++) {
            ApprovedDisplayItem item = itemLst[i];
            if (item.displayItemId ==
                state.selectedApprovedDisplayItem.displayItemId) {
              item.requestedItemCount = item.requestedItemCount - 1;
              if (item.requestedItemCount == 0) {
                itemLst.remove(item);
              }
              updatedSelectedApprovedItem = item;
              break;
            }
          }
          yield state.clone(
            approvedDisplayItemsList: itemLst,
            selectedApprovedDisplayItem: updatedSelectedApprovedItem,
            loading: false,
            itemScanError: false,
            itemScanSuccess: true,
          );
          break;
        } catch (e) {
          yield state.clone(
            loading: false,
            itemScanError: true,
            itemScanSuccess: false,
          );
        }
        break;
      case ClearAllApprovedDisplayItemsEvent:
        yield state.clone(
          loading: true,
          clearAllApprovedSuccess: false,
          clearAllApprovedError: false,
        );
        try {
          await approvedDisplayItemRepository.clearAllApprovedItemsFromAPI(
            labId: rootBloc.state.user.labId,
            studentId: state.student.id,
            token: rootBloc.state.user.token,
          );
          yield state.clone(
            loading: false,
            approvedDisplayItemsList: [],
            clearAllApprovedSuccess: true,
            clearAllApprovedError: false,
          );
        } catch (e) {
          yield state.clone(
            loading: false,
            clearAllApprovedSuccess: false,
            clearAllApprovedError: true,
          );
        }
        break;
      case UpdateDueDateEvent:
        String date = (event as UpdateDueDateEvent).dateString;
        yield state.clone(dueDate: date);
        break;
      case ClearStateEvent:
        yield state.clearState();
        break;
      case SelectDisplayItemToScanItemsEvent:
        ApprovedDisplayItem approvedDspItem =
            (event as SelectDisplayItemToScanItemsEvent).approvedDisplayItem;
        yield state.clone(
          selectedApprovedDisplayItem: approvedDspItem,
        );
        break;
      case ClearSelectedDisplayItemEvent:
        state.clone(
          selectedDisplayItemID: "",
          selectedApprovedItemID: "",
          selectedApprovedDisplayItem: null,
        );
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
