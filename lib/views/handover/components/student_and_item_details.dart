import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';
import 'package:unilabs_app/common_widgets/warning_dialog_title.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/components/approved_display_item_card.dart';

class StudentAndItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final handoverBloc = BlocProvider.of<HandoverBloc>(context);
    return BlocBuilder<HandoverBloc, HandoverState>(builder: (context, state) {
      return state.loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  StudentDetailCard(
                    imgSrc: state.student.imageURL != null
                        ? state.student.imageURL
                        : "",
                    firstName: state.student.firstName.isNotEmpty
                        ? state.student.firstName
                        : state.student.indexNumber,
                    lastName: state.student.lastName.isNotEmpty
                        ? state.student.lastName
                        : "",
                    studentID: state.student.indexNumber,
                    department: state.student.departmentCode,
                  ),
                  SizedBox(height: 10),
                  CustomSmallButton(
                      color: Constants.kDarkPrimary,
                      text: "Scan a New Student ID",
                      onPressed: () {
                        handoverBloc.add(ClearStateEvent());
                      }),
                  SizedBox(height: 10),
                  Text(
                    'Approved Display Items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  state.clearAllApprovedSuccess
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All Approved Items Cleared",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Constants.kSuccessColor,
                            ),
                          ),
                        )
                      : Container(),
                  state.clearAllApprovedError
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Could not clear all approved items.Try again later.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Constants.kErrorColor,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  state.approvedDisplayItemsList.length > 0
                      ? BlocBuilder<HandoverBloc, HandoverState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      state.approvedDisplayItemsList.length,
                                  itemBuilder: (context, index) {
                                    ApprovedDisplayItem approvedItem =
                                        state.approvedDisplayItemsList[index];
                                    return ApprovedDisplayItemCard(
                                      displayItemName:
                                          approvedItem.displayItemName,
                                      requestedQuantity: approvedItem
                                          .requestedItemCount
                                          .toString(),
                                      imgSrc:
                                          approvedItem.displayItemImageURL !=
                                                  null
                                              ? approvedItem.displayItemImageURL
                                              : '',
                                      onTap: () {
                                        handoverBloc.add(
                                          SelectDisplayItemToScanItemsEvent(
                                            approvedDisplayItem: approvedItem,
                                          ),
                                        );
                                        handoverBloc.add(
                                          ChangeHandoverStepEvent(
                                            nextStep: HandoverProcessStep
                                                .ItemScanStep,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                CustomSmallButton(
                                    color: Constants.kErrorColor,
                                    text: "Clear All Approved Display Items",
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => new AlertDialog(
                                          title: WarningDialogTitle(
                                            title: "Are You Sure?",
                                          ),
                                          content: AlertDialogBody(
                                            content:
                                                "Do you want to clear all the approved items for this student from this lab.",
                                          ),
                                          actions: <Widget>[
                                            DialogButton(
                                              color: Constants.kSuccessColor,
                                              text: "Don't Clear",
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                            DialogButton(
                                                color: Constants.kErrorColor,
                                                text: "Clear All",
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  handoverBloc.add(
                                                      ClearAllApprovedDisplayItemsEvent());
                                                }),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            );
                          },
                        )
                      : Text(
                          "No Approved Items Available for this Student.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Constants.kErrorColor,
                          ),
                        ),
                ],
              ),
            );
    });
  }
}
