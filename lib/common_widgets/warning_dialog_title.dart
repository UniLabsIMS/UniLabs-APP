import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/constants.dart';

class WarningDialogTitle extends StatelessWidget {
  final String title;
  WarningDialogTitle({this.title = "Warning"});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          FontAwesomeIcons.exclamationTriangle,
          color: Constants.kWarningColor,
          size: 64,
        ),
        SizedBox(height: 15),
        Center(child: Text(title, textAlign: TextAlign.center)),
      ],
    );
  }
}
