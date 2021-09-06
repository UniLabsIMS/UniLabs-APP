import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;
  DialogButton(
      {@required this.color, @required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
            letterSpacing: 1.15,
            color: color,
          ),
        ),
      ),
    );
  }
}
