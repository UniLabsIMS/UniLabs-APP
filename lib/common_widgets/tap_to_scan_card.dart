import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/constants.dart';

class TapToScanCard extends StatelessWidget {
  final Function onTap;
  final String text;
  final double fontSize;
  TapToScanCard({
    @required this.onTap,
    @required this.text,
    this.fontSize = 24,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        dashPattern: [8, 4],
        strokeWidth: 2,
        color: Constants.kPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.barcode,
                size: 124,
                color: Constants.kHintText,
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    color: Constants.kPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
