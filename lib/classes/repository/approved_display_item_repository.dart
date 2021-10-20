import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';
import 'package:unilabs_app/classes/api/approved_display_item.dart';

class ApprovedDisplayItemRepository {
  static Dio dio = Dio();

  Future<List<ApprovedDisplayItem>> getApprovedItemsFromAPI(
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

  Future<void> clearAllApprovedItemsFromAPI(
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
