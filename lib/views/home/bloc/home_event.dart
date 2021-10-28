import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent {}

class ErrorEvent extends LoginEvent {
  final String error;

  ErrorEvent(this.error);
}

class LogoutEvent extends LoginEvent {}
