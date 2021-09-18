import 'package:flutter/material.dart';

@immutable
class HomeState {
  final String error;
  final bool loading;
  final bool logoutError;

  HomeState({
    @required this.error,
    @required this.loading,
    @required this.logoutError,
  });

  static HomeState get initialState => HomeState(
        error: '',
        loading: false,
        logoutError: false,
      );

  HomeState clone({
    String error,
    bool loading,
    bool logoutError,
  }) {
    return HomeState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      logoutError: logoutError ?? this.logoutError,
    );
  }
}
