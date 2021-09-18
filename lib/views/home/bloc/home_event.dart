import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent {}

class ErrorEvent extends HomeEvent {
  final String error;

  ErrorEvent(this.error);
}

class LogoutEvent extends HomeEvent {}
