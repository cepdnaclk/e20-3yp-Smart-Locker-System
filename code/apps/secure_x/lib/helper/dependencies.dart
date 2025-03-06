import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/data/api/dio_client.dart'; // Use DioClient
import 'package:secure_x/data/repository/auth_repo.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Register SharedPreferences
  Get.lazyPut(() => sharedPreferences);

  // Initialize DioClient
  Get.lazyPut(() => DioClient());

  // Initialize AuthRepo with DioClient and SharedPreferences
  Get.lazyPut(() => AuthRepo(
    dioClient: Get.find(), // Use DioClient
    sharedPreferences: Get.find(),
  ));

  // Initialize AuthController with AuthRepo
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
}