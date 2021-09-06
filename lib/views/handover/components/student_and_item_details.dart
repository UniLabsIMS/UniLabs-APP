import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: Column(
        children: [
          StudentDetailCard(
            firstName: "First",
            lastName: "Last",
            studentID: "180594V",
            department: "CSE",
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
          BlocBuilder<HandoverBloc, HandoverState>(
            builder: (context, state) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ApprovedDisplayItemCard(
                    displayItemName: "Display Item Name",
                    requestedQuantity: "03",
                    imgSrc:
                        'https://www.sigmaaldrich.com/deepweb/content/dam/sigma-aldrich/product7/075/cls1003_c_sm.tif/_jcr_content/renditions/cls1003_c_sm-large.jpg',
                    onTap: () {
                      handoverBloc.add(
                        SelectDisplayItemToScanItemsEvent(
                          displayItemId: "123",
                        ),
                      );
                      handoverBloc.add(
                        ChangeHandoverStepEvent(
                            nextStep: HandoverProcessStep.ItemScanStep),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
