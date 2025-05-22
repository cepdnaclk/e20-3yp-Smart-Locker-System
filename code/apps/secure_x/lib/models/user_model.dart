class UserModel{
  String? id;
  String? firstName;
  String? lastName; 
  String? email;
  String? phoneNo;
  String? regNo;
  late bool isUserSignedIn;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.regNo,
    this.isUserSignedIn=false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    print("User JSON: $json"); // 🔍 DEBUG LINE

    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNo = json['contact_number'];
    regNo = json['username'];
    isUserSignedIn = false;
  }


  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=Map<String,dynamic>();
    data['id']=id;
    data['email']=email;
    data['first_name']=firstName;
    data['last_name']=lastName;
    data['contact_number']=phoneNo;
    data['reg_no'] = regNo;
    return data; 
  } 

}