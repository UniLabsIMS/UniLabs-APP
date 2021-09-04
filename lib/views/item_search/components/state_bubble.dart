import 'package:flutter/material.dart';

class StateBubble extends StatelessWidget {
  final String stateName;
  final Color color;
  StateBubble({
    @required this.stateName,
    @required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
          child: Text(
            stateName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.15,
              color: Colors.white,
            ),
          ),
        ));
  }
}
