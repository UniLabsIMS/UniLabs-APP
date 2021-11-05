import 'package:flutter/material.dart';

import '../../../constants.dart';

class BorrowedItemCard extends StatelessWidget {
  final String displayItemName;
  final String itemID;
  final String dueDate;
  final String state;

  BorrowedItemCard({
    @required this.displayItemName,
    @required this.itemID,
    @required this.dueDate,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Constants.kDarkPrimary),
          color: Constants.kScaffoldBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 1,
              offset: Offset(0, 0.25),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            itemID,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            displayItemName + " \nDue on: " + dueDate,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            state.replaceAll("_", ". "),
            style: TextStyle(color: Constants.kSuccessColor),
          ),
        ),
      ),
    );
  }
}
