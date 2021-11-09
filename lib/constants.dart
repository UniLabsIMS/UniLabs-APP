import 'package:flutter/material.dart';

/// Constants used in the app
abstract class Constants {
  // Official colors

  static final Color kPrimary = Colors.teal;
  static final Color kDarkPrimary = Color(0xFF006666);
  static final Color kSecondary = Colors.pink;
  static final Color kScaffoldBackground = Colors.white;
  static final Color kAppBarBackground = Color(0xFFF5F5F5);
  static final Color kCanvasBackground = Colors.white;
  static final Color kDivider = Color(0xFF8E8E8E);
  static final Color kHintText = Color(0xFF8E8E8E);
  static final Color kSuccessColor = Colors.green;
  static final Color kErrorColor = Colors.red;
  static final Color kWarningColor = Colors.yellow[700];

  static final String kBarcodeScannerColor = "#009688";

  //user role
  static final String kLabAssistantRole = 'Lab_Assistant';

  // Default large screen sizes
  static final double kMaxButtonWidth = 700;
  static final double kMaxHomeDetailWidth = 1000;

  //Images
  static final String kDefaultProfileImageURL =
      'https://img.favpng.com/22/17/15/user-computer-icons-anonymity-png-favpng-Ps1EmXsrUx17SLTQrTeDg1FN5.jpg';
  static final String kSearchItemImage = "assets/images/search_item.jpg";
  static final String kHandoverItemsImage = "assets/images/handover_items.jpg";
  static final String kTemporaryHandoverImage =
      "assets/images/temporary_handover.jfif";
  static final String kReturnItemsImage = "assets/images/accept_items.jfif";
  static final String kDefaultItemImageURL =
      "https://media.istockphoto.com/vectors/laboratory-beakers-icon-chemical-experiment-in-flasks-hemistry-and-vector-id1165295631?k=20&m=1165295631&s=612x612&w=0&h=WA8ZWrwyKmGUGjoU77iHDl_P5vT4ewRaSVdlDQP9BS8=";
}
