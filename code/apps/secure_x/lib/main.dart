import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/controllers/user_controller.dart';
//import 'package:secure_x/find.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:secure_x/sign_in.dart';
//import 'package:secure_x/create_user.dart';
import 'package:secure_x/pages/log_in.dart';
//import 'package:secure_x/home.dart';
//import 'package:secure_x/sign_in.dart';
//import 'package:secure_x/user.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>();
    Get.find<UserController>();

    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
      //home: HomePage(),
    );
  }
}



