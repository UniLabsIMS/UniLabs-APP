import 'package:flutter/material.dart';

class AlertDialogBody extends StatelessWidget {
  final String content;
  AlertDialogBody({@required this.content});
  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: TextAlign.center,
    );
  }
}
