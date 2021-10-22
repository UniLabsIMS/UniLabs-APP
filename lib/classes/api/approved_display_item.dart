import 'package:dio/dio.dart';

class ApprovedDisplayItem {
  String id;
  String displayItemId;
  String displayItemName;
  String displayItemImageURL;
  String displayItemDescription;
  int totalItemCount;
  int requestedItemCount;
  static Dio dio = Dio();
  ApprovedDisplayItem({
    this.id,
    this.displayItemId,
    this.displayItemName,
    this.displayItemImageURL,
    this.displayItemDescription,
    this.totalItemCount,
    this.requestedItemCount,
  });
}
