import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/tap_to_scan_card.dart';
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
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/home");
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
                                  "#009688",
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
}
