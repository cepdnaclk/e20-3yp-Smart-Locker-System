import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthController _authController = Get.find<AuthController>();

  final _formKey=GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _regNoController;
  late TextEditingController _phoneNoController;

  @override
  void initState(){
    super.initState();
    final user=_authController.userModel.value;

    //initialize controllers with current user data
    _emailController=TextEditingController(text: user?.email ?? '');
    _firstNameController=TextEditingController(text: user?.firstName ?? '');
    _lastNameController=TextEditingController(text: user?.lastName ?? '');
    _regNoController=TextEditingController(text: user?.regNo ?? '');
    _phoneNoController=TextEditingController(text: user?.phoneNo ?? '');
  }

  @override
  void dispose(){
    //Dispose the controllers when widget is removed
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _regNoController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final user = _authController.userModel.value;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: Text('No user data available'))
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //User Image
                  ClipOval(
                    child: Image.asset('assets/img/userImage.png',
                    width:160,
                    height:160,
                    fit:BoxFit.cover,),
                  ),
              
                  SizedBox(height: 24,),

                  _buildEditableField("Email",_emailController),
                  _buildEditableField("First Name", _firstNameController),
                  _buildEditableField("Last Name", _lastNameController),
                  _buildEditableField("Registration No", _regNoController),
                  _buildEditableField("Phone Number", _phoneNoController),

                  SizedBox(height: 24,),
                  
                  SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor2,
                        foregroundColor: AppColors.buttonBackgroundColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          await _authController.updateProfile(UserModel(
                            id: user.id,
                            email: _emailController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            regNo: _regNoController.text,
                            phoneNo: _phoneNoController.text,
                            role: user.role,
                          )
                        );
                        }
                      }, 
                      child: const Text('Submit')),
                  )
                ],
              ),
      ),
      ),
    );
  }

  Widget _buildEditableField(String title,TextEditingController controller,{bool readOnly=false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: 
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: (value) => value==null || value.isEmpty ? 'Please enter $title':null,
        style:const TextStyle(
          color: AppColors.appBarColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.appBarColor,
            )
          ),
          filled: true,
          fillColor: AppColors.boxColor,
          )
        ),
      );
  }
}
