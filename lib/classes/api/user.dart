import 'package:dio/dio.dart';

import '../../api_endpoints.dart';

class User {
  String id;
  String token;
  String email;
  String firstName;
  String lastName;
  String imageURL;
  String role;
  String department;
  String lab;
  String contactNo;
  bool blocked;

  User({
    this.id,
    this.token,
    this.email,
    this.firstName,
    this.lastName,
    this.imageURL,
    this.role,
    this.department,
    this.lab,
    this.contactNo,
    this.blocked,
  });
  static Future<User> loginToWithEmailPassword(
      String email, String password) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        APIEndpoints.kLoginURL,
        data: {"email": email, "password": password},
      );
      print(response.data);
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
        lab: data['other_details']['lab']['name'],
        contactNo: data["contact_number"],
        blocked: data["blocked"] == "true",
      );
    } on DioError catch (e) {
      print(e.toString());
      print(e.response.data);
      return null;
    }
  }

  static Future<User> getFromAPIWithToken(String token) async {
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
        lab: data['other_details']['lab']['name'],
        contactNo: data["contact_number"],
        blocked: data["blocked"] == "true",
      );
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
  }
}
