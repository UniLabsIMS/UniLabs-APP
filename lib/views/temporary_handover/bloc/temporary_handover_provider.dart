import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/common_widgets/success_dialog_title.dart';
import 'package:unilabs_app/views/temporary_handover/temporary_handover_page.dart';

import '../../../constants.dart';
import 'temporary_handover_bloc.dart';
import 'temporary_handover_state.dart';

class TemporaryHandoverProvider extends BlocProvider<TemporaryHandoverBloc> {
  TemporaryHandoverProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => TemporaryHandoverBloc(context),
          child: TemporaryHandoverView(),
        );
}

class TemporaryHandoverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TemporaryHandoverBloc, TemporaryHandoverState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
        BlocListener<TemporaryHandoverBloc, TemporaryHandoverState>(
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
        BlocListener<TemporaryHandoverBloc, TemporaryHandoverState>(
          listenWhen: (pre, current) =>
              pre.handoverSuccess != current.handoverSuccess,
          listener: (context, state) {
            if (state.handoverSuccess)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: SuccessDialogTitle(
                    title: "Item Temp. Handover Successful",
                  ),
                  content: AlertDialogBody(
                    content:
                        "Item marked as temporally handed over to the student.",
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
        BlocListener<TemporaryHandoverBloc, TemporaryHandoverState>(
          listenWhen: (pre, current) =>
              pre.handoverError != current.handoverError,
          listener: (context, state) {
            if (state.handoverError)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item Temp. Handover Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "The system could not temporally handover this item to student. Make sure the item is marked as \"Available\" and belongs to your lab. You may search the item to see more details about it.",
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
      child: TemporaryHandoverPage(),
    );
  }
}
