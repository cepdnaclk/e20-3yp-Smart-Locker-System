class CreateUserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String regNo;
  final String phoneNo;
  final String password;

  CreateUserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.regNo,
    required this.phoneNo,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'reg_no': regNo,
      'contact_number': phoneNo,
      'password': password,
    };
  }
}