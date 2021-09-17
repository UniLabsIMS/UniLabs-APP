import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/common_widgets/success_dialog_title.dart';
import 'package:unilabs_app/views/item_return/returning_item_page.dart';

import '../../../constants.dart';
import 'item_return_bloc.dart';
import 'item_return_state.dart';

class ItemReturnProvider extends BlocProvider<ItemReturnBloc> {
  ItemReturnProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => ItemReturnBloc(context),
          child: ItemReturnView(),
        );
}

class ItemReturnView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ItemReturnBloc, ItemReturnState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
        BlocListener<ItemReturnBloc, ItemReturnState>(
          listenWhen: (pre, current) =>
              pre.studentSearchError != current.studentSearchError,
          listener: (context, state) {
            if (state.studentSearchError)
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
        BlocListener<ItemReturnBloc, ItemReturnState>(
          listenWhen: (pre, current) =>
              pre.itemAcceptanceSuccess != current.itemAcceptanceSuccess,
          listener: (context, state) {
            if (state.itemAcceptanceSuccess)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: SuccessDialogTitle(
                    title: "Returning Item Acceptance Successful",
                  ),
                  content: AlertDialogBody(
                    content: "Item marked as received.",
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
        BlocListener<ItemReturnBloc, ItemReturnState>(
          listenWhen: (pre, current) =>
              pre.itemAcceptanceError != current.itemAcceptanceError,
          listener: (context, state) {
            if (state.itemAcceptanceError)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item Acceptance Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "The system could not accept the returning item. Make sure the item is one of the items borrowed by the particular student.",
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
      child: ReturningItemPage(),
    );
  }
}
