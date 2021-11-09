import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/root_bloc/root_event.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  RootBloc rootBloc;
  UserRepository userRepository;
  HomeBloc(
      BuildContext context, RootBloc rootBloc, UserRepository userRepository)
      : super(HomeState.initialState) {
    this.rootBloc = rootBloc;
    this.userRepository = userRepository;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case LogoutEvent:
        yield state.clone(loading: true, logoutError: false);
        try {
          await userRepository.logOut(token: rootBloc.state.user.token);
          rootBloc.add(LogOutEvent());
        } catch (e) {
          yield state.clone(loading: true, logoutError: true);
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
