import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ],
      child: HandoverPage(),
    );
  }
}
