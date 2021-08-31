import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // ignore: close_sinks
    final itemSearchBloc = BlocProvider.of<ItemSearchBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ItemSearchBloc, ItemSearchState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
      ],
      child: ItemSearchPage(),
    );
  }
}
