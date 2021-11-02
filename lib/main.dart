import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilabs_app/classes/repository/user_repository.dart';
import 'package:unilabs_app/root_bloc/root_bloc.dart';
import 'package:unilabs_app/theme/theme.dart';
import 'package:unilabs_app/views/handover/bloc/handover_provider.dart';
import 'package:unilabs_app/views/home/bloc/home_provider.dart';
import 'package:unilabs_app/views/item_return/bloc/item_return_provider.dart';
import 'package:unilabs_app/views/item_search/bloc/item_search_provider.dart';
import 'package:unilabs_app/views/login/bloc/login_provider.dart';
import 'splash.dart';
import 'package:unilabs_app/views/temporary_handover/bloc/temporary_handover_provider.dart';

void main() {
  runApp(UniLabsApp());
}

// This widget is the root of your application.
class UniLabsApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RootBloc>(
          create: (context) => RootBloc(context, UserRepository()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Uni Labs',
        theme: buildThemeData(context),
        initialRoute: '/',
        routes: {
          "/": (context) => SplashScreen(),
          "/login": (context) => LoginProvider(),
          "/home": (context) => HomeProvider(),
          "/search": (context) => ItemSearchProvider(),
          "/handover": (context) => HandoverProvider(),
          "/temp-handover": (context) => TemporaryHandoverProvider(),
          "/item-return": (context) => ItemReturnProvider(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
