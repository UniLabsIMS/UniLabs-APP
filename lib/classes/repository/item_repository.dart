import 'package:dio/dio.dart';
import 'package:unilabs_app/classes/api/item.dart';

import '../../api_endpoints.dart';

class ItemRepository {
  static const AvailableState = "Available";
  static const DamagedState = "Damaged";
  static Dio dio = Dio();

  Future<Item> getFromAPI({String itemID, String token}) async {
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

  Future<void> changeItemState(
      {String itemID, String token, String state}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.patch(
      APIEndpoints.kItemStateChangeURL + itemID,
      data: {"state": state},
    );
  }

  Future<void> deleteItem({String itemID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.delete(APIEndpoints.kItemDeleteURL + itemID);
  }

  Future<void> tempHandover(
      {String itemID, String studentUUID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.post(
      APIEndpoints.kItemTempHandoverURL + itemID,
      data: {"student_uuid": studentUUID},
    );
  }

  Future<void> acceptReturningItem({String itemID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.put(
      APIEndpoints.kReturningItemURL + itemID,
    );
  }

  Future<void> approvedItemHandover(
      {String itemID, String token, String approvalId, String dueDate}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.post(
      APIEndpoints.kItemHandoverURL + itemID,
      data: {"request_item_id": approvalId, "due_date": dueDate},
    );
  }
}
