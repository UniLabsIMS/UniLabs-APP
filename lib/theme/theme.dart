import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unilabs_app/constants.dart';

/// Theme data for the app and color scheme to be used
ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal,
    primarySwatch: Colors.teal,
    appBarTheme: AppBarTheme(
      elevation: 2,
      shadowColor: Colors.black,
      centerTitle: true,
      color: Constants.kAppBarBackground,
      titleTextStyle: GoogleFonts.rubik(
        textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 26,
            color: Colors.black,
            letterSpacing: 1),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    textTheme: GoogleFonts.rubikTextTheme(
      Theme.of(context).textTheme,
    ),
    scaffoldBackgroundColor: Constants.kScaffoldBackground,
    canvasColor: Constants.kCanvasBackground,
  );
}
