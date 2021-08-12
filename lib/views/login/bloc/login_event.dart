import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent {}

class ErrorEvent extends LoginEvent {
  final String error;

  ErrorEvent(this.error);
}

class TogglePasswordVisiblityEvent extends LoginEvent {}

class SubmitEvent extends LoginEvent {
  final Map<String, String> auth;

  SubmitEvent(this.auth);
}
