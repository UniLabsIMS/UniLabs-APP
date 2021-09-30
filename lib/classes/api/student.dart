import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';

class Student {
  String id;
  String indexNumber;
  String email;
  String firstName;
  String lastName;
  String imageURL;
  String departmentName;
  String departmentCode;
  String contactNo;
  static Dio dio = Dio();

  Student({
    this.id,
    this.indexNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.imageURL,
    this.departmentName,
    this.departmentCode,
    this.contactNo,
  });

  static Future<Student> getFromAPI({String studentID, String token}) async {
    String tokenAPI = "Token " + token;
    dio.options.headers["Authorization"] = tokenAPI;
    Response response = await dio.get(
      APIEndpoints.kStudentSearchURL + studentID,
    );
    final data = response.data;
    return Student(
      id: data['id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      indexNumber: data['student_id'],
      email: data['email'],
      imageURL: data['image'],
      departmentName: data['department']['name'],
      departmentCode: data['department']['code'],
      contactNo: data["contact_number"],
    );
  }
}
