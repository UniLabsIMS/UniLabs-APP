import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<HandoverBloc, HandoverState>(
        builder: (context, state) {
          return Column(
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
                  text: "Scan New Student ID",
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
              SizedBox(height: 20),
              state.approvedDisplayItemsList.length > 0
                  ? BlocBuilder<HandoverBloc, HandoverState>(
                      builder: (context, state) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.approvedDisplayItemsList.length,
                          itemBuilder: (context, index) {
                            ApprovedDisplayItem approvedItem =
                                state.approvedDisplayItemsList[index];
                            return ApprovedDisplayItemCard(
                              displayItemName: approvedItem.displayItemName,
                              requestedQuantity:
                                  approvedItem.requestedItemCount.toString(),
                              imgSrc: approvedItem.displayItemImageURL != null
                                  ? approvedItem.displayItemImageURL
                                  : 'https://www.sigmaaldrich.com/deepweb/content/dam/sigma-aldrich/product7/075/cls1003_c_sm.tif/_jcr_content/renditions/cls1003_c_sm-large.jpg',
                              onTap: () {
                                handoverBloc.add(
                                  SelectDisplayItemToScanItemsEvent(
                                    approvedDisplayItem: approvedItem,
                                  ),
                                );
                                handoverBloc.add(
                                  ChangeHandoverStepEvent(
                                    nextStep: HandoverProcessStep.ItemScanStep,
                                  ),
                                );
                              },
                            );
                          },
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
          );
        },
      ),
    );
  }
}
