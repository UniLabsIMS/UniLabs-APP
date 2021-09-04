import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/views/handover/bloc/handover_bloc.dart';
import 'package:unilabs_app/views/handover/bloc/handover_event.dart';
import 'package:unilabs_app/views/handover/bloc/handover_state.dart';
import 'package:unilabs_app/views/handover/components/student_and_item_details.dart';

import '../../constants.dart';

class HandoverPage extends StatelessWidget {
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final handoverBloc = BlocProvider.of<HandoverBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        bool confirmed = await _onWillPop(context);
        if (confirmed) Navigator.pushReplacementNamed(context, "/home");
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Item Handover',
            style: TextStyle(letterSpacing: 1.5),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<HandoverBloc, HandoverState>(
            builder: (context, state) {
              return (state.loading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (state.student == null)
                      ? Center(
                          child: TapToScanCard(
                            text: "Tap to Scan Student ID",
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
                                    SearchStudentAndApprovedItemsEvent(
                                      studentID: barcode,
                                    ),
                                  );
                                }
                              } on PlatformException {}
                            },
                          ),
                        )
                      : StudentAndItemDetails();
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: Text('Do you want to exit and return to home page'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
