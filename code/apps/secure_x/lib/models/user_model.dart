class UserModel{
  String? id;
  String? firstName;
  String? lastName; 
  String? email;
  String? phoneNo;
  String? regNo;
  String? role;
  late bool isUserSignedIn;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.regNo,
    this.role,
    this.isUserSignedIn=false,
  });

  UserModel.fromJson(Map<String,dynamic>json){

      print("User JSON: $json");

      id=json['id'];
      firstName=json['firstName'];
      lastName=json['lastName'];
      email= json['email']; 
      phoneNo= json['contactNumber'];
      regNo = json['username'];
      role=json['role'];
      isUserSignedIn=false;
  }


  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=Map<String,dynamic>();
    data['id']=id;
    data['email']=email;
    data['firstName']=firstName;
    data['lastName']=lastName;
    data['contactNumber']=phoneNo;
    data['username'] = regNo;
    data['role']=role;
    return data; 
  } 

}