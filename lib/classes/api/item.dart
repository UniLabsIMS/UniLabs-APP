import 'package:dio/dio.dart';

import '../../api_endpoints.dart';

class Item {
  String id;
  String state;
  String parentDisplayItemName;
  String parentDisplayItemImageURL;
  String parentDisplayItemDescription;
  String categoryName;
  String labName;
  static const AvailableState = "Available";
  static const DamagedState = "Damaged";
  static Dio dio = Dio();
  Item({
    this.id,
    this.state,
    this.parentDisplayItemName,
    this.parentDisplayItemImageURL,
    this.parentDisplayItemDescription,
    this.categoryName,
    this.labName,
  });
  static Future<Item> getFromAPI({String itemID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    Response response = await dio.get(
      APIEndpoints.kItemSearchURL + itemID,
    );
    final data = response.data;
    return Item(
      id: data['id'],
      state: data['state'],
      parentDisplayItemName: data['display_item']['name'],
      parentDisplayItemImageURL: data['display_item']['image'] == null
          ? ""
          : data['display_item']['image'],
      parentDisplayItemDescription: data['display_item']['description'],
      categoryName: data['item_category']["name"],
      labName: data["lab"]["name"],
    );
  }

  static Future<void> changeItemState(
      {String itemID, String token, String state}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.patch(
      APIEndpoints.kItemStateChangeURL + itemID,
      data: {"state": state},
    );
  }

  static Future<void> deleteItem({String itemID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.delete(APIEndpoints.kItemDeleteURL + itemID);
  }

  static Future<void> tempHandover(
      {String itemID, String studentUUID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.post(
      APIEndpoints.kItemTempHandoverURL + itemID,
      data: {"student_uuid": studentUUID},
    );
  }

  static Future<void> acceptReturningItem({String itemID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.put(
      APIEndpoints.kReturningItemURL + itemID,
    );
  }

  Item clone() {
    return Item(
      id: id,
      state: state,
      parentDisplayItemName: parentDisplayItemName,
      parentDisplayItemImageURL: parentDisplayItemImageURL,
      parentDisplayItemDescription: parentDisplayItemDescription,
      categoryName: categoryName,
      labName: labName,
    );
  }
}
