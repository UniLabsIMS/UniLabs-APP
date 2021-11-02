import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
import 'package:unilabs_app/common_widgets/warning_dialog_title.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_bloc.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_event.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_state.dart';
import 'package:unilabs_app/views/item_search/components/item_details.dart';

class ItemSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final itemSearchBloc = BlocProvider.of<ItemSearchBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        bool confirmed = await _onWillPop(context);
        if (confirmed) Navigator.pushReplacementNamed(context, "/home");
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Item Search',
            style: TextStyle(letterSpacing: 1.5),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<ItemSearchBloc, ItemSearchState>(
            builder: (context, state) {
              return (state.loading)
                  ? Center(child: CircularProgressIndicator())
                  : (state.item == null)
                      ? Center(
                          child: TapToScanCard(
                            text: "Tap to Scan Item",
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
                                  itemSearchBloc.add(
                                    SearchItemWithBarCodeEvent(
                                        barcode: barcode),
                                  );
                                }
                              } on PlatformException {}
                            },
                          ),
                        )
                      : ItemDetails();
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
            title: WarningDialogTitle(
              title: "Are You Sure?",
            ),
            content: AlertDialogBody(
              content: "Do you want to exit and return to the home page?",
            ),
            actions: <Widget>[
              DialogButton(
                color: Constants.kErrorColor,
                text: "No",
                onPressed: () => Navigator.of(context).pop(false),
              ),
              DialogButton(
                color: Constants.kSuccessColor,
                text: "Yes",
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        )) ??
        false;
  }
}
