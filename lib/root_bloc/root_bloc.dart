import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/constants.dart';
import 'root_event.dart';
import 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  UserRepository userRepository;
  RootBloc(BuildContext context, UserRepository userRepository)
      : super(RootState.initialState) {
    this.userRepository = userRepository;
    _initialize();
  }

  Future<void> _initialize() async {
    Future.delayed(Duration(seconds: 2), () => add(CheckStartedEvent()));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token') ?? '');
    if (token.isNotEmpty) {
      print('Token >>>>>>>>>>>>>>>>>>>>> $token');
      final user = await userRepository.getFromAPIWithToken(token);
      if (user != null) {
        print('Logged In >>>>>>>>>>>>>>>>>>>>> ${user.id}');
        await Future.delayed(Duration(seconds: 1));
        if (user.role == Constants.kLabAssistantRole) {
          add(UpdateUserEvent(user));
          add(ChangeLogInStateEvent(LoginStateType.LOGIN));
        } else {
          await Future.delayed(Duration(seconds: 3));
          print('Not Lab Assistant User >>>>>>>>>>>>>>>>>>');
          add(ChangeLogInStateEvent(LoginStateType.LOGOUT));
        }
      } else {
        await Future.delayed(Duration(seconds: 3));
        print('Token Invalid or Request Failed >>>>>>>>>>>>>>>>>>');
        add(ChangeLogInStateEvent(LoginStateType.LOGOUT));
      }
    } else {
      print('No Saved Token >>>>>>>>>>>>>>>>>>');
      await Future.delayed(Duration(seconds: 3));
      add(ChangeLogInStateEvent(LoginStateType.LOGOUT));
    }
  }

  @override
  Stream<RootState> mapEventToState(RootEvent event) async* {
    switch (event.runtimeType) {
      case ErrorRootEvent:
        final error = (event as ErrorRootEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;

      case CheckStartedEvent:
        yield state.clone(checkStarted: true);
        break;

      case UpdateUserEvent:
        final user = (event as UpdateUserEvent).user;
        yield state.clone(user: user);
        break;

      case ChangeLogInStateEvent:
        final stateLogin = (event as ChangeLogInStateEvent).state;
        yield state.clone(loginState: stateLogin);
        break;

      case LogInAndSaveTokenEvent:
        final user = (event as LogInAndSaveTokenEvent).user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);
        yield state.clone(
          loginState: LoginStateType.LOGIN,
          user: user,
        );
        break;

      case LogOutEvent:
        yield state.clone(loginState: LoginStateType.CHECKING);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', '');
        yield state.clone(loginState: LoginStateType.LOGOUT);
        print('User Logged Out >>>>>>>>>>>>>>>>>>>');
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
      add(ErrorRootEvent((e is String)
          ? e
          : (e.message ?? "Something went wrong. Please try again!")));
    } catch (e) {
      add(ErrorRootEvent("Something went wrong. Please try again!"));
    }
  }
}
