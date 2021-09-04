import 'package:flutter/material.dart';
import 'package:unilabs_app/common_widgets/student_details_card.dart';

class StudentAndItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StudentDetailCard(
            firstName: "First",
            lastName: "Last",
            studentID: "180594V",
            department: "CSE",
          )
        ],
      ),
    );
  }
}
