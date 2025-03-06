class UserModel{
  int? id;
  String? username;
  String? email;
  int? phoneNo;
  late bool isUserSignedIn;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.phoneNo,
    this.isUserSignedIn=false,
  });

  UserModel.fromJson(Map<String,dynamic>json){
      id:json['id'];
      username:json['first_name'];
      email: json['email']; 
      phoneNo: json['contact_number'];
      isUserSignedIn=false;
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=Map<String,dynamic>();
    data['id']=id;
    data['email']=email;
    data['first_name']=username;
    data['contact_number']=phoneNo;
    return data; 
  } 

}