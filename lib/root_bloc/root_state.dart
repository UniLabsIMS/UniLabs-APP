import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/user.dart';

enum LoginState { CHECKING, LOGIN, LOGOUT }

@immutable
class RootState {
  final String error;
  final User user;
  final LoginState loginState;
  final bool checkStarted;

  RootState({
    @required this.error,
    @required this.user,
    @required this.loginState,
    @required this.checkStarted,
  });

  static RootState get initialState => RootState(
        error: '',
        user: null,
        loginState: LoginState.CHECKING,
        checkStarted: false,
      );

  RootState clone({
    String error,
    User user,
    LoginState loginState,
    bool checkStarted,
  }) {
    return RootState(
      error: error ?? this.error,
      user: user ?? this.user,
      loginState: loginState ?? this.loginState,
      checkStarted: checkStarted ?? this.checkStarted,
    );
  }
}
