import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_bloc.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_event.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_state.dart';
import 'package:unilabs_app/views/item_return/components/borrowed_item_card.dart';

import '../../../constants.dart';

class ItemAcceptanceScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final itemReturnBloc = BlocProvider.of<ItemReturnBloc>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<ItemReturnBloc, ItemReturnState>(
        builder: (context, state) {
          return Column(
            children: [
              StudentDetailCard(
                firstName: "First",
                lastName: "Last",
                studentID: "180594V",
                department: "CSE",
              ),
              CustomSmallButton(
                  color: Constants.kDarkPrimary,
                  text: "Scan a New Student ID",
                  onPressed: () {
                    itemReturnBloc.add(ResetStateEvent());
                  }),
              SizedBox(height: 30),
              (state.borrowedItems.length > 0)
                  ? Column(
                      children: [
                        TapToScanCard(
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
                                itemReturnBloc.add(
                                  ScanAndAcceptItemEvent(
                                      scannedItemID: barcode),
                                );
                              }
                            } on PlatformException {}
                          },
                          text: "Tap to Scan and Accept Returning Item",
                          fontSize: 18,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Make sure to scan only borrowed items by the above student.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.kErrorColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Borrowed Items",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.borrowedItems.length,
                          itemBuilder: (context, index) {
                            return BorrowedItemCard(
                              displayItemName: "Diaply Item Name",
                              itemID: "132454uyZ",
                              dueDate: "2021/09/27",
                              state: "Borrowed",
                            );
                          },
                        ),
                      ],
                    )
                  : Text(
                      "No Items Are Currently Borrowed By This Student.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.kDarkPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
