import 'package:get/get.dart';
import 'package:secure_x/data/repository/user_repo.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/models/user_model.dart';

class UserController extends GetxController implements GetxService{
  final UserRepo userRepo;
  UserController({
    required this.userRepo,
  }
  );

  bool _isloading=false;
  late UserModel _userModel;

  bool get isLoading=> _isloading;
  UserModel get userModel=>_userModel;

  Future<ResponseModel> getUserInfo() async{
    _isloading=true;
    Response response=await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if(response.statusCode==200){
      _userModel=UserModel.fromJson(response.body);
      responseModel=ResponseModel(true,'successfull');
    }else{
      responseModel=ResponseModel(false,response.statusText!);
    }
    _isloading=false;
    update();
    return responseModel;
  }

}