import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/views/home/home.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomeProvider extends BlocProvider<HomeBloc> {
  HomeProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => HomeBloc(context),
          child: HomeView(),
        );
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
      ],
      child: HomePage(),
    );
  }
}
