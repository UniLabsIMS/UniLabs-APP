import 'package:dio/dio.dart';
import 'package:unilabs_app/classes/api/user.dart';

import '../../api_endpoints.dart';

class UserRepository {
  Future<User> loginToWithEmailPassword(String email, String password) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        APIEndpoints.kLoginURL,
        data: {"email": email, "password": password},
      );
      final data = response.data;
      return User(
        id: data['id'],
        token: data['token'],
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        imageURL: data['image'],
        role: data['role'],
        department: data['other_details']['department']['name'],
        labId: data['other_details']['lab']['id'],
        lab: data['other_details']['lab']['name'],
        contactNo: data["contact_number"],
        blocked: data["blocked"] == "true",
      );
    } catch (e) {
      return null;
    }
  }

  Future<User> getFromAPIWithToken(String token) async {
    Dio dio = Dio();
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    try {
      Response response = await dio.get(
        APIEndpoints.kRefreshAuthURL,
      );
      final data = response.data;
      return User(
        id: data['id'],
        token: token,
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        imageURL: data['image'],
        role: data['role'],
        department: data['other_details']['department']['name'],
        labId: data['other_details']['lab']['id'],
        lab: data['other_details']['lab']['name'],
        contactNo: data["contact_number"],
        blocked: data["blocked"] == "true",
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> logOut({String token}) async {
    Dio dio = Dio();
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    await dio.post(APIEndpoints.kLogoutURL);
  }
}
