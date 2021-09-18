import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/common_widgets/success_dialog_title.dart';
import '../../../constants.dart';
import '../item_search_page.dart';

import 'item_search_bloc.dart';
import 'item_search_state.dart';

class ItemSearchProvider extends BlocProvider<ItemSearchBloc> {
  ItemSearchProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => ItemSearchBloc(context),
          child: ItemSearchView(),
        );
}

class ItemSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              print("ERROR: ${state.error}");
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) => pre.searchError != current.searchError,
          listener: (context, state) {
            if (state.searchError) {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item Scan Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "Make sure item is registered in the system and internet connectivity is available.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kErrorColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) => pre.deleteError != current.deleteError,
          listener: (context, state) {
            if (state.deleteError) {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item Deletion Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "Make sure the item is registered in the system and internet connectivity is available.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kErrorColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) =>
              pre.deletionSuccess != current.deletionSuccess,
          listener: (context, state) {
            if (state.deletionSuccess) {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: SuccessDialogTitle(
                    title: "Item Deletion Successful",
                  ),
                  content: AlertDialogBody(
                    content: "Item deleted successfully.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kSuccessColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) =>
              pre.stateChangeSuccess != current.stateChangeSuccess,
          listener: (context, state) {
            if (state.stateChangeSuccess) {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: SuccessDialogTitle(
                    title: "Item State Change Successful",
                  ),
                  content: AlertDialogBody(
                    content: "Item state changed successfully.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kSuccessColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) =>
              pre.stateChangeError != current.stateChangeError,
          listener: (context, state) {
            if (state.stateChangeError) {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Item State Change Failed",
                  ),
                  content: AlertDialogBody(
                    content:
                        "Make sure the item is registered in the system and internet connectivity is available.",
                  ),
                  actions: <Widget>[
                    DialogButton(
                        color: Constants.kErrorColor,
                        text: "Ok",
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              );
            }
          },
        ),
      ],
      child: ItemSearchPage(),
    );
  }
}
