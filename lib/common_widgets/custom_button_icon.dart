import 'package:flutter/material.dart';
import 'package:unilabs_app/constants.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final IconData icon;
  final double marginHorizontal;
  final double textSize;
  final bool loading;

  CustomIconButton({
    @required this.text,
    @required this.onTap,
    this.icon,
    this.marginHorizontal,
    this.textSize,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double marginHorizontalButton = screenWidth - 50 < Constants.kMaxButtonWidth
        ? 0
        : (screenWidth - Constants.kMaxButtonWidth - 50) / 2;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10, horizontal: marginHorizontal ?? marginHorizontalButton),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Constants.kPrimary,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          splashColor: Colors.black12,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Icon(
                        icon,
                        color: Colors.white,
                      )
                    : Container(),
                SizedBox(
                  width: icon == null ? 0 : 20,
                ),
                !loading
                    ? Text(
                        text,
                        style: TextStyle(
                          letterSpacing: 1.25,
                          fontSize: textSize ?? 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Center(
                        child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
