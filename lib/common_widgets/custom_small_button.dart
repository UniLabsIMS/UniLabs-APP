import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;
  CustomSmallButton(
      {@required this.color, @required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 40,
          )),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
            letterSpacing: 1.15,
          ),
        ),
      ),
    );
  }
}
