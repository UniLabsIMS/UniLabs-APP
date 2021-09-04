import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
              showToast(
                "OOPS! Item Search Failed",
                context: context,
                position: StyledToastPosition.bottom,
                duration: Duration(seconds: 4),
                backgroundColor: Colors.red,
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) => pre.deleteError != current.deleteError,
          listener: (context, state) {
            if (state.deleteError) {
              showToast(
                "OOPS! Item Deletion Failed",
                context: context,
                position: StyledToastPosition.bottom,
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              );
            }
          },
        ),
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) =>
              pre.deletionSuccess != current.deletionSuccess,
          listener: (context, state) {
            if (state.deletionSuccess) {
              showToast(
                "Item Successfully removed",
                context: context,
                position: StyledToastPosition.bottom,
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              );
            }
          },
        ),
      ],
      child: ItemSearchPage(),
    );
  }
}
