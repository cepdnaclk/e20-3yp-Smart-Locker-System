class UserModel{
  int id;
  String name;
  String email;
  String phoneNo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
  });

  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      id:json['id'],
      name:json['first_name'],
      email: json['email'], 
      phoneNo: json['contact_number']
    );
  } 

}