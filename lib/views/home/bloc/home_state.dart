import 'package:flutter/material.dart';

@immutable
class HomeState {
  final String error;

  HomeState({
    @required this.error,
  });

  static HomeState get initialState => HomeState(
        error: '',
      );

  HomeState clone({
    String error,
  }) {
    return HomeState(
      error: error ?? this.error,
    );
  }
}
