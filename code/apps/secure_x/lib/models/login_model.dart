class LoginModel{
  final String username;
  final String password;

  LoginModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;

    return data;
  }
}