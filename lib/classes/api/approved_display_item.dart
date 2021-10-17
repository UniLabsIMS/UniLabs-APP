import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';

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

  static Future<List<ApprovedDisplayItem>> getApprovedItemsFromAPI(
      {String labId, String studentId, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    Response response = await dio.get(
      APIEndpoints.kAllApprovedItemsURL + '$labId/$studentId',
    );
    final List dataList = response.data;
    List<ApprovedDisplayItem> approvedDisplayItems = [];
    for (var i = 0; i < dataList.length; i++) {
      Map data = dataList[i];
      ApprovedDisplayItem item = new ApprovedDisplayItem(
        id: data["id"],
        displayItemId: data["display_item"]["id"],
        displayItemName: data['display_item']['name'],
        displayItemImageURL: data['display_item']['image'] == null
            ? ""
            : data['display_item']['image'],
        displayItemDescription: data['display_item']['description'],
        totalItemCount: data['display_item']['item_count'],
        requestedItemCount: data['quantity'],
      );
      approvedDisplayItems.add(item);
    }
    return approvedDisplayItems;
  }

  static Future<void> clearAllApprovedItemsFromAPI(
      {String labId, String studentId, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.put(
      APIEndpoints.kClearAllRemainingApprovedItemsURL,
      data: {"student": studentId, "lab": labId},
    );
    return;
  }
}
