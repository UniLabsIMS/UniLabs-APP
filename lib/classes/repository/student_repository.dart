import 'package:dio/dio.dart';
import 'package:unilabs_app/api_endpoints.dart';
import 'package:unilabs_app/classes/api/student.dart';

class StudentRepository {
  static Dio dio = Dio();
  Future<Student> getFromAPI({String studentID, String token}) async {
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
