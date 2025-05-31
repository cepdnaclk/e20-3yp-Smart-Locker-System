import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Unlock extends StatelessWidget {
  
  Unlock({super.key});

  final AuthController authController=Get.find<AuthController>();
  void _accessLocker(BuildContext context){
    authController.accessLocker();
  }

  void _unassignLocker(BuildContext context){
    authController.unassignLocker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 800,
              height: 350,
              alignment: Alignment.center,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.5,
                  child: Image.asset(
                    'assets/img/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location : xxxxxxxx ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Access Time : xx:xx:xx ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Locker No : xxx ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 60,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.buttonBackgroundColor1,
                backgroundColor: AppColors.buttonBackgroundColor2,
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.black, width: 3.0),
                ),
                padding: const EdgeInsets.all(60),
              ),
              onPressed: () => _accessLocker(context),
              child: const Text('Access', style: TextStyle(fontSize: 22)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.buttonBackgroundColor1,
                backgroundColor: AppColors.iconColor,
                shape: const CircleBorder(
                  side: BorderSide(color: AppColors.iconColor, width: 3.0),
                ),
                padding: const EdgeInsets.all(60),
              ),
              onPressed: () => _unassignLocker(context),
              child: const Text('Unassign', style: TextStyle(fontSize: 22)),
            ),
            ] 
          ),
          const SizedBox(height: 30),
          
        ],
      ),
    );
  }
}
