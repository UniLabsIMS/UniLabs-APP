import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RootBloc, RootState>(
        listenWhen: (previous, current) =>
            previous.loginState != current.loginState,
        listener: (context, state) {
          print(
            'Listener Detected Login State >>>>>>>>>>>>>>> ${state.loginState}',
          );
          if (state.loginState == LoginStateType.LOGOUT) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state.loginState == LoginStateType.LOGIN) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        buildWhen: (previous, current) =>
            previous.checkStarted != current.checkStarted,
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 170,
                      width: 170,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'UniLabs',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Constants.kDarkPrimary,
                      letterSpacing: 2.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Inventory Management System"),
                  SizedBox(height: 20),
                  state.checkStarted
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(height: 36)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
