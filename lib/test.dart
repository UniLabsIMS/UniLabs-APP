import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  final String word;
  TestScreen({@required this.word});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(this.word),
      ),
    );
  }
}
