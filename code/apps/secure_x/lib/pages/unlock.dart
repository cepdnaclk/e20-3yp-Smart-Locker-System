import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class Unlock extends StatelessWidget {
  const Unlock({super.key});

  // Method to handle unlocking the locker
  void _unlockLocker(BuildContext context) async {
    final AuthController authController = Get.find(); // Get the AuthController instance
    final String? token = await authController.getUserToken(); // Retrieve the token

    // Debug: Print the token
    print('Token: $token');

    if (token == null) {
      // Debug: Print error if token is missing
      print('Error: User not authenticated');
      CustomSnackBar('User not authenticated', iserror: true); // Show error if token is missing
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Debug: Print sending unlock request
      print('Sending unlock request...');

      // Send the unlock request to the backend
      final response = await authController.unlockLocker(token);

      // Debug: Print API response
      print('API Response: ${response.message}');

      // Close the loading indicator
      Navigator.of(context).pop();

      if (response.isSuccess) {
        // Debug: Print success message
        print('Locker unlocked successfully');

        // Show success message
        CustomSnackBar(response.message, iserror: false, title: 'Success');

        // Navigate to the LoginSuccess page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginSuccess()),
        );
      } else {
        // Debug: Print error message
        print('Failed to unlock locker: ${response.message}');

        // Show error message
        CustomSnackBar(response.message, iserror: true);
      }
    } catch (e) {
      // Debug: Print unexpected error
      print('Unexpected error: $e');

      // Close the loading indicator
      Navigator.of(context).pop();

      // Show error message
      CustomSnackBar('An unexpected error occurred: $e', iserror: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: const CustomAppBar(),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [         
          Center(
            child: Container(
              width: 800,
              height:350,
              alignment: Alignment.center,
              child:ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.5,
                  child: Image.asset('assets/img/logo.png',
                  fit: BoxFit.cover,             
                ),
                ),
              )             
            ),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.black,width:3.0),
                  ),
                  padding: const EdgeInsets.all(60),
                ),
                onPressed: () => _unlockLocker(context),
                child: const Text('Unlock', style: TextStyle(
                  fontSize: 22)),
          ),
          const SizedBox(height: 30),
          Container(
            padding:const EdgeInsets.all(20),
            margin:const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child:const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text('Location : xxxxxxxx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                 Text('Access Time : xx:xx:xx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                 Text('Locker No : xxx ', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            )
          ),
        ],
        ),
    );
  }
}