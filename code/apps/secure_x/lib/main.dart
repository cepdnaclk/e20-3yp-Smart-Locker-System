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
  final authController = Get.find<AuthController>();
  await authController.authRepo.clearUserToken();

  await Resources.loadResources(); // Load resources
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>(); // Initialize AuthController
    //Size size = MediaQuery.of(context).size;
    //print('Screen width: ${size.width}, height: ${size.height}');
    return ScreenUtilInit(
      designSize: const Size(411.4, 914.3),
      //A11 Screen width: 411.42857142857144, height: 843.4285714285714
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
/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.4, 914.3), // Use your design's base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignIn(),
        );
      },
    );
  }
}*/

