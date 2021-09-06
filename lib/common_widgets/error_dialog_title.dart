import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/constants.dart';

class ErrorDialogTitle extends StatelessWidget {
  final String title;
  ErrorDialogTitle({this.title = "OOPS! Error"});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          FontAwesomeIcons.times,
          color: Constants.kErrorColor,
          size: 64,
        ),
        SizedBox(height: 15),
        Center(child: Text(title, textAlign: TextAlign.center)),
      ],
    );
  }
}
