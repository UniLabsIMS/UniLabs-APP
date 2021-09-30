import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/components/date_picker.dart';

class ItemScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final handoverBloc = BlocProvider.of<HandoverBloc>(context);
    return WillPopScope(
      onWillPop: () {
        handoverBloc.add(ClearSelectedDisplayItemEvent());
        handoverBloc.add(
            ChangeHandoverStepEvent(nextStep: HandoverProcessStep.InitialStep));
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Item Scan',
            style: TextStyle(letterSpacing: 1.5),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: BlocBuilder<HandoverBloc, HandoverState>(
            builder: (context, state) {
              return (state.loading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            "Display Item Name",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 32),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Remaining Requested Item Count",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "04",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 36),
                          ),
                          SizedBox(height: 10),
                          DatePicker(
                            selectedDate: state.dueDate,
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: TapToScanCard(
                              text:
                                  "Tap to Scan and Handover and Item Belonging to Requested Display Item.",
                              fontSize: 20,
                              onTap: () async {
                                try {
                                  String barcode =
                                      await FlutterBarcodeScanner.scanBarcode(
                                    Constants.kBarcodeScannerColor,
                                    'Cancel',
                                    true,
                                    ScanMode.BARCODE,
                                  );
                                  if (barcode != "-1") {
                                    handoverBloc.add(
                                      HandoverScannedItemEvent(
                                        scannedItemID: barcode,
                                      ),
                                    );
                                  }
                                } on PlatformException {}
                              },
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
