import 'package:flutter/material.dart';
import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';

@immutable
abstract class RootEvent {}

class ErrorRootEvent extends RootEvent {
  final String error;

  ErrorRootEvent(this.error);
}

class LogInAndSaveTokenEvent extends RootEvent {
  final User user;

  LogInAndSaveTokenEvent(this.user);
}

class UpdateUserEvent extends RootEvent {
  final User user;

  UpdateUserEvent(this.user);
}

class ChangeLogInStateEvent extends RootEvent {
  final LoginState state;

  ChangeLogInStateEvent(this.state);
}

class LogOutEvent extends RootEvent {}

class CheckStartedEvent extends RootEvent {}

class RefreshEmployeeEvent extends RootEvent {}
