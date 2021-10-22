import 'package:dio/dio.dart';

class BorrowedItem {
  String id;
  String state;
  String dueDate;
  String displayItemName;
  String displayItemImageURL;
  static Dio dio = Dio();

  BorrowedItem({
    this.id,
    this.state,
    this.dueDate,
    this.displayItemName,
    this.displayItemImageURL,
  });
}
