import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';
import 'package:unilabs_app/classes/api/borrowed_item.dart';

class BorrowedItemRepository {
  static Dio dio = Dio();

  Future<List<BorrowedItem>> getBorrowedItemsByStudent(
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
