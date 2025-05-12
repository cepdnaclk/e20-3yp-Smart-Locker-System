class UserModel{
  int? id;
  String? username;
  String? email;
  int? phoneNo;
  String? regNo;
  late bool isUserSignedIn;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.phoneNo,
    this.regNo,
    this.isUserSignedIn=false,
  });

  UserModel.fromJson(Map<String,dynamic>json){
      id=json['id'];
      username=json['first_name'];
      email= json['email']; 
      phoneNo= json['contact_number'];
      regNo = json['reg_no'];
      isUserSignedIn=false;
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=Map<String,dynamic>();
    data['id']=id;
    data['email']=email;
    data['first_name']=username;
    data['contact_number']=phoneNo;
    data['reg_no'] = regNo;
    return data; 
  } 

}