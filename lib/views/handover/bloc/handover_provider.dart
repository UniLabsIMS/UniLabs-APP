import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/common_widgets/success_dialog_title.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/handover/handover_page.dart';

import 'handover_bloc.dart';
import 'handover_state.dart';

class HandoverProvider extends BlocProvider<HandoverBloc> {
  HandoverProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => HandoverBloc(context),
          child: HandoverView(),
        );
}

class HandoverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HandoverBloc, HandoverState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
        BlocListener<HandoverBloc, HandoverState>(
          listenWhen: (pre, current) =>
              pre.studentIDScanError != current.studentIDScanError,
          listener: (context, state) {
            if (state.studentIDScanError)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! ID Scan Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "Make sure the student is registered in the system.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kErrorColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
          },
        ),
        BlocListener<HandoverBloc, HandoverState>(
          listenWhen: (pre, current) =>
              pre.itemScanSuccess != current.itemScanSuccess,
          listener: (context, state) {
            if (state.itemScanSuccess)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: SuccessDialogTitle(
                    title: "Item Handover Successful",
                  ),
                  content: AlertDialogBody(
                    content: "Item marked as handed over to the student.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kSuccessColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
          },
        ),
        BlocListener<HandoverBloc, HandoverState>(
          listenWhen: (pre, current) =>
              pre.itemScanError != current.itemScanError,
          listener: (context, state) {
            if (state.itemScanError)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item Handover Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "The system could not handover this item to student. Make sure the item is under the selected display item and the item is not marked as \"Damaged\"",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kErrorColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
          },
        ),
      ],
      child: HandoverPage(),
    );
  }
}
