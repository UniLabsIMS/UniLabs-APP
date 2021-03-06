import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_bloc.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_event.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_state.dart';

import '../../../constants.dart';

class ItemScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final tempHandoverBloc = BlocProvider.of<TemporaryHandoverBloc>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<TemporaryHandoverBloc, TemporaryHandoverState>(
        builder: (context, state) {
          return Column(
            children: [
              StudentDetailCard(
                imgSrc: state.student.imageURL != null
                    ? state.student.imageURL
                    : Constants.kDefaultProfileImageURL,
                firstName: state.student.firstName.isNotEmpty
                    ? state.student.firstName
                    : "Name",
                lastName: state.student.lastName.isNotEmpty
                    ? state.student.lastName
                    : "Not Set",
                studentID: state.student.indexNumber,
                department: state.student.departmentCode,
              ),
              SizedBox(height: 50),
              TapToScanCard(
                onTap: () async {
                  try {
                    String barcode = await FlutterBarcodeScanner.scanBarcode(
                      Constants.kBarcodeScannerColor,
                      'Cancel',
                      true,
                      ScanMode.BARCODE,
                    );
                    if (barcode != "-1") {
                      tempHandoverBloc.add(
                        ScanAndTempHandoverItemEvent(scannedID: barcode),
                      );
                    }
                  } on PlatformException {}
                },
                text: "Tap to Scan and Temporarily Handover Item to Student",
                fontSize: 18,
              ),
              SizedBox(height: 90),
              CustomSmallButton(
                  color: Constants.kDarkPrimary,
                  text: "Scan New Student ID",
                  onPressed: () {
                    tempHandoverBloc.add(ResetStateEvent());
                  }),
            ],
          );
        },
      ),
    );
  }
}
