import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _selectedImage=File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = _authController.userModel.value;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/backpattern.jpg',
          fit: BoxFit.cover,
      ), 
      Padding(
        padding: EdgeInsets.all(16.h),
        child: user == null
            ? const Center(child: Text('No user data available'))
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipOval(
                        child: _selectedImage!=null? Image.file(
                          _selectedImage! ,
                          width: 150.w,
                          height: 150.h,
                          fit: BoxFit.cover) : Image.asset('assets/img/userImage.png',
                          width: 150.w,
                          height: 150.h,
                          fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            backgroundColor: AppColors.buttonBackgroundColor2,
                            child: Icon(Icons.camera_alt,color: Colors.white,),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (_selectedImage !=null)
                    Padding(
                      padding:EdgeInsets.only(top: 12.h),
                      child: ElevatedButton(
                        onPressed: _authController.isUploadingImage.value ? null : () async {
                          await _authController.uploadProfileImage(_selectedImage!, context);

                          setState(() {
                            _selectedImage =null;
                          });
                        }, 
                        child: _authController.isUploadingImage.value ? CircularProgressIndicator(): Text('Upload Image')
                        ),
                        ),
                  

                  //User Image
                  //ClipOval(
                  //  child: Image.asset('assets/img/userImage.png',
                  //  width:150.w,
                  //  height:150.h,
                  //  fit:BoxFit.cover,),
                  //),
              
                  SizedBox(height: 24.h,),

                  _buildEditableField("Email",_emailController),
                  _buildEditableField("First Name", _firstNameController),
                  _buildEditableField("Last Name", _lastNameController),
                  _buildEditableField("Registration No", _regNoController,readOnly: true),
                  _buildEditableField("Phone Number", _phoneNoController),
                  
                  _buildEditableField("ID", TextEditingController(text: user.id ?? ''), readOnly: true),
                  
                  SizedBox(height: 24.h,),
                  
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 6.h,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, 
                            horizontal: 24.h
                          ),
                        backgroundColor: AppColors.buttonBackgroundColor2,
                        foregroundColor: AppColors.buttonBackgroundColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        )
                      ),
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          await _authController.updateProfile(
                            //id: user.id,
                            email: _emailController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            //regNo: user.regNo,
                            phoneNo: _phoneNoController.text,
                            //role: user.role,
                            context: context,
                        );
                        }
                      }, 
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),)),
                ],
              ),
      ),
      ),
    ]));
  }

  Widget _buildEditableField(String title,TextEditingController controller,{bool readOnly=false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: 
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: (value) => value==null || value.isEmpty ? 'Please enter $title':null,
        style:TextStyle(
          color: AppColors.appBarColor,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
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
