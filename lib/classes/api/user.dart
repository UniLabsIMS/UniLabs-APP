class User {
  String id;
  String firstName;
  String lastName;
  String role;
  String token;
  String lab;

  static Future<User> getFromAPIWithToken(String token) {
    return null;
  }

  static Future<User> loginToWithEmailPassword(String email, String password) {
    return null;
  }
}
