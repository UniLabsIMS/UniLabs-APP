import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';
import 'package:unilabs_app/views/login/login.dart';

import 'login_bloc.dart';
import 'login_state.dart';

class LoginProvider extends BlocProvider<LoginBloc> {
  LoginProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => LoginBloc(
            context,
            BlocProvider.of<RootBloc>(context),
            UserRepository(),
          ),
          child: LoginView(),
        );
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false)
              print("ERROR: ${state.error}");
          },
        ),
        BlocListener<RootBloc, RootState>(
          listenWhen: (pre, current) => pre.loginState != current.loginState,
          listener: (context, state) {
            if (state.loginState == LoginStateType.LOGIN)
              Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ],
      child: LoginPage(),
    );
  }
}
