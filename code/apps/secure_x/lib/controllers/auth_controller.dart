import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:secure_x/data/repository/auth_repo.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/locker_logs_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:secure_x/data/api/dio_client.dart';
import 'package:secure_x/utils/custom_snackbar.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  final DioClient dioClient = DioClient(); // Add this line

  AuthController({required this.authRepo});

  var isLoading = false.obs; // Observable for loading state
  var userModel = UserModel().obs; // Observable for user data
  var userToken = ''.obs; // Observable to store the token
  var otpCode=''.obs;

  // Method to handle user login
  Future<void> login(String username, String password, BuildContext context) async {
    isLoading.value = true; // Start loading
    print('User entered username: $username'); // Debug print
    print('User entered password: $password'); // Debug print
    print('Attempting to login with username: $username'); // Debug print

    try {
      // Call the login method in AuthRepo
      final ResponseModel<String> response = await authRepo.login(username, password);

      if (response.isSuccess) {
        // Extract the token from the response
        final String token = response.data!; // Assuming data contains the token
        userToken.value = token; // Store the token

        print('Login successful: ${response.message}'); // Debug print
        print('Token: $token'); // Debug print
        //Get.snackbar('Success', response.message); // Show a success message
        //CustomSnackBar(response.message, iserror: false, title: 'Login successful', duration: Duration(seconds: 4));
        /*CustomSnackBar.show(
          message: 'Login successful', 
          title: 'Success', 
          isError: false,
          icon: Icons.check_circle_outline,
          backgroundColor: Colors.green.shade600);*/

        /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green.shade600,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));*/

        CustomSnackBar.show(
          context: context, 
          message: response.message,
          title: 'Success',
          isError: false,
        );

        await Future.delayed(Duration(milliseconds: 1500));
        
        // Fetch the signed-in user's details
        await getSignedInUser();
        // Navigate to the LoginSuccess page
        //Get.offAll(() => LoginSuccess());
        Get.offAll(() => Navigation());
      } else {
        print('Login failed: ${response.message}'); // Debug print
        //Get.snackbar('Error', response.message); // Show an error message
        CustomSnackBar.show(
          context: context, 
          message: response.message,
          title: 'Error',
          isError: true,
        );

      }
    } catch (e) {
      print('An unexpected error occurred during login: $e'); // Debug print
      Get.snackbar('Error', 'An unexpected error occurred: $e'); // Show an error message
      CustomSnackBar.show(
          context: context, 
          message: 'An unexpected error occurred: $e',
          title: 'Error',
          isError: true,
        );

    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Method to handle user registration
  Future<ResponseModel<Map<String, dynamic>>> registration(CreateUserModel createUserModel, BuildContext context) async {
    isLoading.value=true;
    try {
      print('Registration data: ${createUserModel.toJson()}');

      final Map<String, dynamic> registrationData = createUserModel.toJson();

      final ResponseModel<Map<String, dynamic>> response=await authRepo.registration(createUserModel);

      if(response.isSuccess){
        print('Registration successful : ${response.message}');
      
        CustomSnackBar.show(
          context: context, 
          message: response.message,
          title: 'Registration successful',
          isError: false,
          icon: Icons.check_circle_outline,
        );

        return ResponseModel<Map<String, dynamic>> (
          isSuccess: true,
          message: response.message,
          data: response.data,
        );
      }else{
        print('Registration Failed : ${response.message}');
      
        CustomSnackBar.show(
          context: context, 
          message: response.message,
          title: 'Registration Failed',
          isError: true,
        );

        return ResponseModel<Map<String, dynamic>> (
          isSuccess: false,
          message: response.message,
        );
      }
    }catch(e){
      print('An unexpected error occured during registration: $e');

      CustomSnackBar.show(
          context: context, 
          message: 'An unexpected error occured : $e',
          title: 'Error',
          isError: true,
        );

        return ResponseModel<Map<String, dynamic>> (
          isSuccess: false,
          message:'An unexpected error occured : $e',
        );
    }finally{
      isLoading.value=false;
    }
  }

  // Method to get the signed-in user's details
  Future<void> getSignedInUser() async {
    isLoading.value = true; // Start loading
    print('Fetching signed-in user details...'); // Debug print

    try {
      // Fetch the token first
      final token = await authRepo.getUserToken();

      if (token == null) {
        print('No valid token found or token expired. Please log in again.');
        Get.snackbar('Error', 'Session expired. Please log in again.');
         /*CustomSnackBar.show(
          context: context,
          message: 'An unexpected error occurred: $e',
          title: 'Error',
          isError: true,
        );*/
        return; // Token is null, do not continue with fetching user details.
      }

      final ResponseModel response = await authRepo.getSignedInUser();

      if (response.isSuccess) {
        // Update userModel with the fetched data
        userModel.value = response.data; // Assuming data contains UserModel
        print('Fetched user details: ${userModel.value}'); // Debug print
        Get.snackbar('Success', 'User details fetched successfully'); // Show a success message
      } else {
        print('Failed to fetch user details: ${response.message}'); // Debug print
        Get.snackbar('Error', response.message); // Show an error message
      }
    } catch (e) {
      print('An unexpected error occurred while fetching user details: $e'); // Debug print
      Get.snackbar('Error', 'An unexpected error occurred: $e'); // Show an error message
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Method to get the user token
  Future<String?> getUserToken() async {
    print('Fetching user token...'); // Debug print

    try {
      // Assuming the token is stored in AuthRepo or somewhere accessible
      final token = await authRepo.getUserToken(); // Call the corresponding method in AuthRepo
      print('Fetched user token: $token'); // Debug print
      return token;
    } catch (e) {
      print('Error fetching user token: $e'); // Debug print
      return null;
    }
  }

  // Method to unlock the locker
  /*Future<ResponseModel> unlockLocker(String token, int clusterId) async {
    isLoading.value = true; // Start loading
    try {
      print('Sending unlock request to backend for cluster $clusterId...');

      final response = await authRepo.unlockLocker(token, clusterId);

      print('API Response: ${response.message}');

      if (response.isSuccess) {
        return ResponseModel(
          isSuccess: true,
          message: 'Locker unlocked successfully',
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          message: 'Failed to unlock locker: ${response.message}',
        );
      }
    } catch (e) {
      print('Unexpected error during unlock: $e');
      return ResponseModel(
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    } finally {
      isLoading.value = false; // Stop loading
    }
  }*/

  //method to get the user logs
  Future<List<LockerLogsModel>> getUserLogs() async{
    isLoading.value=true;
    try{
      final String? token=await authRepo.getUserToken();
      if(token==null){
        throw Exception('User not authenticated');
      }
      dioClient.updateHeader(token);

      final response=await dioClient.getData(AppConstants.LOCKER_LOGS_URI);

      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((e) => LockerLogsModel.fromJson(e)).toList();
      }else{
        throw Exception('Failed to fetch locker logs: ${response.statusCode}');
      }
    }catch(e){
      print('Error fetching logs: $e');
      Get.snackbar('Error', 'Failed to load user logs: $e');
      return [];
    }finally{
      isLoading.value=false;
    }
  }

  //Method to update user profile
  Future<void> updateProfile(UserModel updatedUser) async{
    isLoading.value=true;

    try{
      final response = await authRepo.UpdateUserProfile(updatedUser);
      if (response.isSuccess){
        userModel.value=updatedUser;
        Get.snackbar("Success", response.message);
      }else{
        Get.snackbar("Error", response.message);
      }
    }catch(e){
      print('Error updating profile: $e');
      Get.snackbar("Error", 'Failed to update profile: $e');
    }finally{
      isLoading.value=false;
    }
  }

  //Method to access the assigned locker
  Future<void> accessLocker() async{
    isLoading.value=true;
    try{
      final String? token=await authRepo.getUserToken();
      if(token==null){
        throw Exception('User not authenticated');
      }
      dioClient.updateHeader(token);
      final response= await dioClient.getData(AppConstants.ACCESS_LOCKER_URI);
      if(response.statusCode==200){
        print('Locker access successful : ${response.data}');
        Get.snackbar('Success','Locker Accessed Successfully');
      }else{
        throw Exception('Failed to access locker: ${response.statusCode}');
      }
    }catch(e){
      print('Error accessing locker : $e');
      Get.snackbar('Error', 'Failed to access locker : $e');
    }finally{
      isLoading.value=false;
    }
  }

  //Method to unassign locker
  Future<void> unassignLocker() async {
    isLoading.value=true;
    try{
        final String? token=await authRepo.getUserToken();
        if(token==null){
          throw Exception('User not authenticated');
        }
        dioClient.updateHeader(token);

        final response= await dioClient.getData(AppConstants.UNASSIGN_LOCKER_URI);

        if(response.statusCode==200){
          print('Locker unassigned successfully: ${response.data}');
          Get.snackbar('Success', 'Locker unassigned successfully');
        }else{
          throw Exception('Failed to unassign locker: ${response.statusCode}');
        }
    }catch(e){
      print('Error unassigning locker: $e');
      Get.snackbar('Error', 'Failed to unassign locker : $e');
    }finally{
      isLoading.value=false;
    }

  }

  //Method to get OTP code
  Future<void> getOTPCode(BuildContext context) async{
    isLoading.value=true;

    try{
      final String? token=await authRepo.getUserToken();

      if(token==null){
        throw Exception('User not authenticated');
      }

      dioClient.updateHeader(token);
      final response=await dioClient.getData(AppConstants.GET_OTP_CODE_URI);

      if(response.statusCode==200){
        otpCode.value=response.data.toString();
        CustomSnackBar.show(
          context: context, 
          message: 'Your OTP Code: ${otpCode.value}',
          title: 'OTP Code',
          icon: Icons.security,
          isError: false,
        );     
      }else{
        throw Exception('Failed to get OTP Code: ${response.statusCode}');
      }
    }catch(e){
      print('Error getting OTP Code: $e');
      CustomSnackBar.show(
        context: context, 
        message: 'Failed to get OTP Code: $e',
        title: 'Error',
        isError: true,
      );
    }finally{
      isLoading.value=false;
    }
  }

  //Method to generate new OTP code
  Future<void> generateNewOTPCode(BuildContext context) async{
    isLoading.value=true;

    try{
      final String? token=await authRepo.getUserToken();

      if(token==null){
        throw Exception('User not authenticated');
      }

      dioClient.updateHeader(token);
      final response=await dioClient.getData(AppConstants.GENERATE_NEW_OTP_CODE_URI);

      if(response.statusCode==200){
        otpCode.value=response.data.toString();
        CustomSnackBar.show(
          context: context, 
          message: 'New OTP Code Generated: ${otpCode.value}',
          title: 'New OTP Code',
          icon: Icons.refresh,
          isError: false,
        );     
      }else{
        throw Exception('Failed to generate new OTP Code: ${response.statusCode}');
      }
    }catch(e){
      print('Error generating new OTP Code: $e');
      CustomSnackBar.show(
        context: context, 
        message: 'Failed to generate new OTP Code: $e',
        title: 'Error',
        isError: true,
      );
    }finally{
      isLoading.value=false;
    }
  }

  //Method to check user approval
  Future<bool> checkApprovalStatus(String email,String password) async{
    return await authRepo.checkApprovalStatus(email, password);
  }


}
