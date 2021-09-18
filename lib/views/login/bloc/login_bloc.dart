import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RootBloc rootBloc;
  LoginBloc(BuildContext context)
      : this.rootBloc = BlocProvider.of<RootBloc>(context),
        super(LoginState.initialState);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case TogglePasswordVisiblityEvent:
        yield state.clone(showPass: !state.showPass);
        break;

      case SubmitEvent:
        yield state.clone(loading: true, loginFailed: false);
        final authDetails = (event as SubmitEvent).auth;
        final user = await User.loginToWithEmailPassword(
            authDetails['email'], authDetails['password']);
        if (user != null) {
          if (user.role == 'Lab_Assistant')
            rootBloc.add(LogInAndSaveTokenEvent(user));
          else
            yield state.clone(loading: false, loginFailed: true);
        } else {
          yield state.clone(loading: false, loginFailed: true);
        }
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    _addErr(error);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    if (e is StateError) return;
    try {
      add(ErrorEvent((e is String)
          ? e
          : (e.message ?? "Something went wrong. Please try again!")));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again!"));
    }
  }
}
