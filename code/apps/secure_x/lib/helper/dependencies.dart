import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/controllers/user_controller.dart';
import 'package:secure_x/data/api/api_client.dart';
import 'package:secure_x/data/repository/auth_repo.dart';
import 'package:secure_x/data/repository/user_repo.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init()async{
  final sharedPreferences=await SharedPreferences.getInstance();

  Get.lazyPut(()=>sharedPreferences);

  Get.lazyPut(()=>ApiClient(appBaseUrl:AppConstants.BASE_URL));

  Get.lazyPut(()=>AuthRepo(apiClient: Get.find(), sharedPreferences:Get.find()));
  Get.lazyPut(()=>UserRepo(apiClient: Get.find(),));

  Get.lazyPut(()=>AuthController(authRepo:Get.find()));
  Get.lazyPut(()=>UserController(userRepo: Get.find()));

}