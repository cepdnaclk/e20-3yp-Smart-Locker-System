import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/routes/route_helper.dart';
import 'package:secure_x/utils/resources.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init(); // Initialize dependencies
  
  // Clear token from SharedPreferences for development testing
  //final authController = Get.find<AuthController>();
  //await authController.authRepo.clearUserToken();

  await Resources.loadResources(); // Load resources
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>(); // Initialize AuthController

    return ScreenUtilInit(
      designSize: const Size(411.4, 914.3),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: RouteHelper.getSplashScreen(),
          getPages: RouteHelper.routes,
      );
      },
    );
  }
}
