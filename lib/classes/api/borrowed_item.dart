import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';

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
  static Future<List<BorrowedItem>> getBorrowedItemsByStudent(
      {String studentUUID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    Response response = await dio.get(
      APIEndpoints.kBorrowedItemsOfStudentURL + studentUUID,
    );
    final List data = response.data;
    List<BorrowedItem> borrowedLst = data
        .map((itemData) => new BorrowedItem(
              id: itemData['item']['id'],
              state: itemData['state'],
              dueDate: itemData['due_date'],
              displayItemName: itemData['item']['display_item']['name'],
              displayItemImageURL: itemData['item']['display_item']['image'],
            ))
        .toList();
    return borrowedLst;
  }
}
