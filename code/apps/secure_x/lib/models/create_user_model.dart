class CreateUserModel {
  String email;
  String userName;
  String phoneNo;
  String password;

  CreateUserModel({
    required this.email,
    required this.userName,
    required this.phoneNo,
    required this.password,
  }
  );

  Map<String, dynamic> toJason(){
    final Map<String, dynamic> data=new Map<String, dynamic>();
    data['name']=this.userName;
    data['contact_number']=this.phoneNo;
    data['email']=this.email;
    data['password']=this.password;
    return data;
  }

  
}