import 'package:flutter/material.dart';
import 'package:unilabs_app/common_widgets/network_avatar.dart';
import 'package:unilabs_app/constants.dart';

class StudentDetailCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String studentID;
  final String department;
  final String imgSrc;

  StudentDetailCard({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.studentID,
    @required this.department,
    this.imgSrc = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double marginHorizontal = screenWidth - 40 < Constants.kMaxHomeDetailWidth
        ? 20
        : (screenWidth - Constants.kMaxHomeDetailWidth) / 2;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 15),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.kDarkPrimary),
        color: Constants.kScaffoldBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 3,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NetworkAvatar(
            radius: 30,
            src: imgSrc,
            err: firstName.isNotEmpty && lastName.isNotEmpty
                ? firstName[0].toUpperCase() + lastName[0].toUpperCase()
                : 'Img',
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  firstName + ' ' + lastName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  studentID + ' - ' + department,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
