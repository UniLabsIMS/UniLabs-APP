import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/constants.dart';

class SuccessDialogTitle extends StatelessWidget {
  final String title;
  SuccessDialogTitle({this.title = "Success"});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          FontAwesomeIcons.checkCircle,
          color: Constants.kSuccessColor,
          size: 64,
        ),
        SizedBox(height: 15),
        Center(child: Text(title, textAlign: TextAlign.center)),
      ],
    );
  }
}
