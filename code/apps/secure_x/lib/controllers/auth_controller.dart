import 'package:get/get.dart';
import 'package:secure_x/data/repository/auth_repo.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/response_model.dart';

class AuthController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo,
  }
  );

  bool _isloading=false;
  bool get isLoading=> _isloading;

  Future<ResponseModel> registraion(CreateUserModel createUserModel) async{
    _isloading=true;
    Response response=await authRepo.registration(createUserModel);
    late ResponseModel responseModel;
    if(response.statusCode==200){

      authRepo.saveUserToken(response.body['token']);
      responseModel=ResponseModel(true,response.body['token']);
    }else{
      responseModel=ResponseModel(false,response.statusText!);
    }
    _isloading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email,String password) async{
    _isloading=true;
    Response response=await authRepo.login(email,password);
    print('Login Response: ${response.body}');
    late ResponseModel responseModel;
    if(response.statusCode==200){    
      authRepo.saveUserToken(response.body['token']);
      print('token'+response.body['token']);
      responseModel=ResponseModel(true,response.body['token']);
    }else{
      responseModel=ResponseModel(false,response.statusText!);
    }
    _isloading=false;
    update();
    return responseModel;
  }

  bool isUserSignedIn() {
    return authRepo.isUserSignedIn();
  }

  void getUserToken() {
    authRepo.getUserToken();
  }

  void clearSharedData() {
    authRepo.clearSharedData();
  }

  void signOut() {
    authRepo.clearSharedData();
    update();
  }


}