import 'package:flutter/material.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/common_widgets/custom_small_button.dart';
import 'package:unilabs_app/constants.dart';

class ItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Item Name",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Item ID",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "DescriptionDescriptio nDescriptionDescrip tionDescription DescriptionDescriptionDescr iptionDescriptionDescriptionD escription",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          CustomSmallButton(
            color: Colors.grey,
            text: "Toggle State",
            onPressed: () {},
          ),
          CustomSmallButton(
            color: Colors.red,
            text: "Delete Item",
            onPressed: () {},
          ),
          SizedBox(height: 20),
          CustomIconButton(text: "Scan Another", onTap: () {})
        ],
      ),
    );
  }
}
