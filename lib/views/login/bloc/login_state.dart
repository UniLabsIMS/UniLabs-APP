import 'package:flutter/material.dart';

@immutable
class LoginState {
  final String error;
  final bool showPass;
  final bool loginFailed;
  final bool loading;
  final bool isArchived;

  LoginState({
    @required this.error,
    @required this.showPass,
    @required this.loginFailed,
    @required this.loading,
    @required this.isArchived,
  });

  static LoginState get initialState => LoginState(
        error: '',
        showPass: false,
        loginFailed: false,
        loading: false,
        isArchived: false,
      );

  LoginState clone({
    String error,
    bool showPass,
    bool loginFailed,
    bool loading,
    bool isArchived,
  }) {
    return LoginState(
      error: error ?? this.error,
      showPass: showPass ?? this.showPass,
      loading: loading ?? this.loading,
      loginFailed: loginFailed ?? this.loginFailed,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
