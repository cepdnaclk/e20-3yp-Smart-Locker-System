import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/user_details.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  // Variable to store the formatted registration number
  String formattedRegNo = "XX/XX/XXX";
  
  // Get the AuthController instance
  final AuthController _authController = Get.find<AuthController>();
  
  @override
  void initState() {
    super.initState();
    // Retrieve registration number when screen loads
    _loadUserRegNo();
  }
  
  // Method to format registration number (E20002 -> E/20/002)
  String _formatRegNo(String regNo) {
    if (regNo == null || regNo.isEmpty) return "XX/XX/XXX";
    
    // For registration number in format 'E20002'
    if (regNo.length >= 6 && regNo[0].toUpperCase() == 'E') {
      return '${regNo[0]}/${regNo.substring(1, 3)}/${regNo.substring(3)}';
    }
    
    // If it doesn't match the expected format, return as is
    return regNo;
  }

  // Load user data from AuthController
  void _loadUserRegNo() {
    // Access the regNo from the userModel in AuthController
    final userRegNo = _authController.userModel.value.regNo;
    
    if (userRegNo != null && userRegNo.isNotEmpty) {
      setState(() {
        formattedRegNo = _formatRegNo(userRegNo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar:const CustomAppBar(),
      body:Container(
        color: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),            
              child:Center(
                child: CircleAvatar(
                  radius:80,
                  backgroundColor:Colors.white,
                  child:ClipOval(
                    child: Image.asset('assets/img/userImage.png',
                    width:160,
                    height:160,
                    fit:BoxFit.cover,
                    )
                  )
                ),
              )
            ),
            const SizedBox(height: 20,),
            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 20,),
                child: Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        formattedRegNo,
                        style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                          Get.to(() => UserDetails());
                          //Navigator.push(
                          //  context,
                          //  MaterialPageRoute(
                          //    builder: (context) => UserDetails(),
                          //  ),
                         // );
                      }, 
                      icon: const Icon(
                        Icons.person_4_outlined,
                        color: Colors.black,
                      ),
                      label: const Text('User Detail',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                          Get.to(() => LockerLogs());
                      }, 
                      icon: const Icon(
                        Icons.history,
                        color: Colors.black,
                      ),
                      label: const Text('User History',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                      const SizedBox(height: 20,),
                      TextButton.icon(
                        onPressed: (){
                      }, 
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      label: const Text('Settings',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),)
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20,)   
          ],
        ),      
      ),
    );    
  }
}
