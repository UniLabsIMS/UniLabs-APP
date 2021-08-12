import 'package:flutter/material.dart';
import 'package:unilabs_app/theme/theme.dart';
import 'package:unilabs_app/views/login/bloc/login_provider.dart';

void main() {
  runApp(UniLabsApp());
}

// This widget is the root of your application.
class UniLabsApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Uni Labs',
        theme: buildThemeData(context),
        initialRoute: '/',
        routes: {
          "/": (context) => LoginProvider(),
        });
  }
}
