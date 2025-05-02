import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';

class Resources{
  static Future<void> loadResources() async {
    try{
        Get.find<AuthController>().getUserToken();
          await Get.find<AuthController>().getSignedInUser();
      }catch(e){
        print('An error occurred while loading resources: $e');
      }
  }
  
}