import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/common_widgets/dialog_body.dart';
import 'package:unilabs_app/common_widgets/dialog_button.dart';
import 'package:unilabs_app/common_widgets/error_dialog_title.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/home/home.dart';

import '../../../constants.dart';
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
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (pre, current) => pre.logoutError != current.logoutError,
          listener: (context, state) {
            if (state.logoutError)
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: ErrorDialogTitle(
                    title: "OOPS! Logging out Failed",
                  ),
                  content: AlertDialogBody(
                    content: "Make sure the device is connected to internet.",
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
        BlocListener<RootBloc, RootState>(
          listenWhen: (pre, current) => pre.loginState != current.loginState,
          listener: (context, state) {
            if (state.loginState == LoginStateType.LOGOUT)
              Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
      child: HomePage(),
    );
  }
}
