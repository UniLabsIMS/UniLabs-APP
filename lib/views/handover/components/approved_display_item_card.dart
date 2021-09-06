import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/constants.dart';

class ApprovedDisplayItemCard extends StatelessWidget {
  final String imgSrc;
  final String displayItemName;
  final String requestedQuantity;
  final Function onTap;
  ApprovedDisplayItemCard({
    @required this.displayItemName,
    @required this.requestedQuantity,
    @required this.onTap,
    this.imgSrc = "",
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
          onTap: onTap,
          leading: NetworkAvatar(
            radius: 30,
            src: imgSrc,
            err: "Img",
          ),
          title: Text(
            displayItemName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "Quantity: " + requestedQuantity,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Icon(FontAwesomeIcons.chevronRight),
        ),
      ),
    );
  }
}
