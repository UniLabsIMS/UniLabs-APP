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
  String labId;
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
    this.labId,
    this.contactNo,
    this.blocked,
  });
}
