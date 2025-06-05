import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:secure_x/data/api/dio_client.dart'; // Use DioClient
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/models/locker_logs_model.dart';
import 'package:secure_x/models/response_model.dart';
import 'package:secure_x/models/user_model.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient; // Use DioClient instead of ApiClient
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  // Method to check if the token has expired
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print('Token decode error: $e');
      return true;
    }
  }

  // Method to get the user token from SharedPreferences
  Future<String?> getUserToken() async {
    try {
      final token = sharedPreferences.getString(AppConstants.TOKEN);
      print('Fetched user token: $token');

      if (token == null || _isTokenExpired(token)) {
        print('Token is null or expired');
        await clearUserToken(); // Clear if invalid
        return null;
      }

      return token;
    } catch (e) {
      print('Error fetching user token: $e');
      return null;
    }
  }

  // Method to clear the user token from SharedPreferences
  Future<void> clearUserToken() async {
    await sharedPreferences.remove(AppConstants.TOKEN);
    print('Token cleared from SharedPreferences');
  }

  // Method to handle user login
  Future<ResponseModel<String>> login(String username, String password) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> loginData = {
        'username': username,
        'password': password,
      };

      print('Sending login request: ${jsonEncode(loginData)}'); // Debug print

      // Send the POST request to the backend
      final response = await dioClient.postData(
        AppConstants.LOG_IN_URI,
        loginData,
      );

      // Debug print to log the response body
      print('Response body: ${response.data}'); // Add this line

      // Check the response status code
      if (response.statusCode == 200) {
        // Directly handle the response body as a Map<String, dynamic>
        final Map<String, dynamic> responseBody = response.data;

        // Extract the token from the response
        final String token = responseBody['token']; // Ensure this matches the API response structure

        // Save the token in SharedPreferences
        sharedPreferences.setString(AppConstants.TOKEN, token);

        // Update the headers in DioClient with the new token
        dioClient.updateHeader(token);

        // Return a success response
        return ResponseModel<String>(
          isSuccess: true,
          message: 'Login successful',
          data: token, // Pass the token as data
        );
      } else if (response.statusCode == 404) {
        // User not found
        return ResponseModel<String>(
          isSuccess: false,
          message: 'User not found',
        );
      } else {
        // Login failed
        return ResponseModel<String>(
          isSuccess: false,
          message: 'Login failed: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during login: $e'); // Debug print
      return ResponseModel<String>(
        isSuccess: false,
        message: 'Network error: $e',
  );
}}
  // Method to handle user registration
  Future<ResponseModel<Map<String, dynamic>>> registration(CreateUserModel createUserModel) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> registrationData = createUserModel.toJson();

      print('Sending registration request: ${jsonEncode(registrationData)}'); // Debug print

      // Send the POST request to the backend
      final response = await dioClient.postData(
        AppConstants.CREATE_USER_URI,
        createUserModel.toJson(),
        requireAuth: false,
      );

      print('Received registration response: ${response.statusCode} - ${response.data}'); // Debug print

      // Check the response status code
      if (response.statusCode == 200) {
        // Registration successful
        final responseData = response.data; // Decode the JSON response

        // Return a ResponseModel with the parsed data
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: true,
          message: 'Registration successful. Your account is pending admin approval.',
          data: responseData,
        );
      } else if(response.statusCode==409){
        //conflict
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: false,
          message: 'User with this email or username already exists',
        );
      } else if (response.statusCode==400){
        //bad request
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: false,
          message: 'Invalid registration data : ${response.data}',
        );
      }else {
        // Registration failed
        return ResponseModel<Map<String, dynamic>>(
          isSuccess: false,
          message: 'Registration failed: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during registration: $e'); // Debug print
      return ResponseModel<Map<String, dynamic>>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  // Method to fetch the signed-in user's details
  Future<ResponseModel<UserModel>> getSignedInUser() async {
    try {
      // Retrieve the token from SharedPreferences
      final String? token = sharedPreferences.getString(AppConstants.TOKEN);

      if (token == null) {
        return ResponseModel<UserModel>(
          isSuccess: false,
          message: 'User not authenticated',
        );
      }

      // Update the headers in DioClient with the current token
      dioClient.updateHeader(token);

      // Send a GET request to fetch the signed-in user's details
      final response = await dioClient.getData(AppConstants.USER_INFO_URI);

      print('Received user details response: ${response.statusCode} - ${response.data}'); // Debug print

      if (response.statusCode == 200) {
        // Parse the response and return a ResponseModel
        final userData = response.data;
        return ResponseModel<UserModel>(
          isSuccess: true,
          message: 'User details fetched successfully',
          data: UserModel.fromJson(userData), // Pass user data to the data field
        );
      } else {
        // Handle errors
        return ResponseModel<UserModel>(
          isSuccess: false,
          message: 'Failed to fetch user details: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during fetching user details: $e'); // Debug print
      return ResponseModel<UserModel>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  // Method to unlock the locker
  /*Future<ResponseModel> unlockLocker(String token, int clusterId) async {
    try {
      // Debug: Print updating headers with token
      print('Updating headers with token: $token');

      // Update headers with the token
      dioClient.updateHeader(token);

      // Prepare request body
      final requestBody = {
        'clusterId': clusterId, // ✅ Pass the required clusterId
      };

      // Debug: Print sending POST request
      print('Sending POST request to: ${AppConstants.UNLOCK_LOCKER_URI} with body: $requestBody');

      // Send the POST request to the backend
      final response = await dioClient.postData(
        AppConstants.UNLOCK_LOCKER_URI,
        requestBody,
      );

      // Debug: Print API response
      print('Received API response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        return ResponseModel(
          isSuccess: true,
          message: 'Locker unlocked successfully',
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          message: 'Failed to unlock locker: ${response.data}',
        );
      }
    } catch (e) {
      print('Network error during unlock: $e');
      return ResponseModel(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }*/

  //method to get the user logs
  Future<List<LockerLogsModel>> getUserLogs() async{
    // Retrieve the token from SharedPreferences
    final String? token = sharedPreferences.getString(AppConstants.TOKEN);

    if (token == null) {
      throw Exception('User not authenticated');         
    }

    // Update the headers in DioClient with the current token
    dioClient.updateHeader(token);

    try{
      final response=await dioClient.getData(AppConstants.LOCKER_LOGS_URI,);
      if(response.statusCode==200){
        List<dynamic> data= response.data;
        return data.map((e)=> LockerLogsModel.fromJson(e)).toList();
      }else{
        throw Exception('Failed to fetch locker logs: ${response.statusCode}');
      }
    }catch(e){
      print('Error fetching logs: $e');
      throw e;
    }
  }

  //Method to update user profile
  Future<ResponseModel> UpdateUserProfile(UserModel updatedUser) async{
    try{
      // Retrieve the token from SharedPreferences
      final String? token = sharedPreferences.getString(AppConstants.TOKEN);

      if (token == null) {
        return ResponseModel(
          isSuccess: false,
          message: 'User not authenticated',
        );
      }

      // Update the headers in DioClient with the current token
      dioClient.updateHeader(token);

      // Debug: Print the updated user data
      print('Updating user profile with data: ${updatedUser.toJson()}');

      // Send the PUT request to update user profile
      final response = await dioClient.putData(
        AppConstants.EDIT_PROFILE_URI,
        updatedUser.toJson(),
      );

      if (response.statusCode == 200) {
        return ResponseModel(
          isSuccess: true,
          message: 'Profile updated successfully',
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          message: 'Failed to update profile: ${response.data}',
        );
      }
    } catch (e) {
      print('Error during profile update: $e');
      return ResponseModel(
        isSuccess: false,
        message: 'Error: $e',
      );
    }
  }

  //Method to Access the assigned locker
  Future<ResponseModel> accessLocker() async{
    try{
      final String? token=sharedPreferences.getString(AppConstants.TOKEN);

      if(token==null){
        throw Exception('User not authenticated');
      }

      List<LockerLogsModel> lockerLogs= await getUserLogs();
      LockerLogsModel? activeLocker;

      try{
        activeLocker=lockerLogs.firstWhere(
        (log)=> log.status=='ACTIVE',);

        print('[DEBUG] Active locker found!');
        print('[DEBUG] Active Locker Details:');
        print('[DEBUG] - ID: ${activeLocker.id}');
        print('[DEBUG] - DateTime: ${activeLocker.dateTime}');
        print('[DEBUG] - Status: ${activeLocker.status}');
        print('[DEBUG] - Cluster ID: ${activeLocker.clusterId}');

      }catch(e){
        activeLocker=null;
      }
     
      if(activeLocker==null){
        return ResponseModel(
          isSuccess: false, 
          message: 'No active lockers found',);
      }

      final response=await dioClient.postData(AppConstants.ACCESS_LOCKER_URI, {});
      if (response.statusCode == 200) {
        return ResponseModel(
          isSuccess: true,
          message: 'Locker accessed successfully',
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          message: 'Error in accessing locker: ${response.data}',
        );
      }
    }catch(e){
      print('Access Locker Error : $e');
      return ResponseModel(
        isSuccess: false, 
        message: 'Error : $e',);
    }
  }

  //Method to unassign the assigned locker
  Future<ResponseModel> unassignLocker(String token) async{
    try{
      final String? token=sharedPreferences.getString(AppConstants.TOKEN);

      if(token==null){
        throw Exception('User not authenticated');
      }

      List<LockerLogsModel> lockerLogs= await getUserLogs();
      LockerLogsModel? activeLocker;

      try{
        activeLocker=lockerLogs.firstWhere(
        (log)=> log.status=='ACTIVE',);
      }catch(e){
        activeLocker=null;
      }
     
      if(activeLocker==null){
        return ResponseModel(
          isSuccess: false, 
          message: 'No active lockers found',);
      }

      final response=await dioClient.postData(AppConstants.UNASSIGN_LOCKER_URI,{});
      if (response.statusCode == 200) {
        return ResponseModel(
          isSuccess: true,
          message: 'Locker unassigned successfully',
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          message: 'Error in unassigning locker: ${response.data}',
        );
      }
    }catch(e){
      print('Unassign Locker Error : $e');
      return ResponseModel(
        isSuccess: false, 
        message: 'Error : $e',);
    }
  }

  //Method to get OTP code
  Future<ResponseModel<String>> getOtpCode() async{
    try{
      final String? token=sharedPreferences.getString(AppConstants.TOKEN);

      if(token==null){
        return ResponseModel<String>(
          isSuccess:false,
          message: 'User not authenticated' );
      }

      dioClient.updateHeader(token);
      final response = await dioClient.getData(AppConstants.GET_OTP_CODE_URI);

      print('Received OTP code response: ${response.statusCode}- ${response.data}');

      if(response.statusCode==200){
        return ResponseModel<String>(
          isSuccess: true,
          message: 'OTP code fetched successfully',
          data: response.data.toString(),
        );
      }else{
        return ResponseModel<String>(
          isSuccess: false, 
          message: 'Failed to fetch OTP code: ${response.data}',
        );
      }
    }catch(e){
      print('Error fetching OTP code: $e');
      return ResponseModel<String>(
        isSuccess: false,
        message: 'Network error: $e',
      );
    }
  }

  //Method to generate new OTP code
  Future<ResponseModel<String>> generateNewOtpCode() async{
    try{
      final String? token=sharedPreferences.getString(AppConstants.TOKEN);

      if(token==null){
        return ResponseModel<String>(
          isSuccess: false,
          message: 'User not authenticated',
        );
      }

      dioClient.updateHeader(token);

      final response=await dioClient.getData(AppConstants.GENERATE_NEW_OTP_CODE_URI);

      print('Received new OTP code response: ${response.statusCode}- $response.data');

      if(response.statusCode==200){
        return ResponseModel<String>(
          isSuccess: true,
          message: 'OTP code retrieved successfully',
          data: response.data.toString(),
        );
      }else{
        return ResponseModel<String>(
          isSuccess:false,
          message: 'Failed to get OTP code : ${response.data}',
        );
      }
    }catch(e){
      print('Error generating new OTP code: $e');
      return ResponseModel(
        isSuccess: false, 
        message: 'Network error: $e',
      );
    }
  }

  //check approval status
  Future<bool> checkApprovalStatus(String email, String password) async{
    try{
      final response=await dioClient.postData(
        AppConstants.LOG_IN_URI,
        {
          'email': email,
          'password':password,
        },
      );

      if(response.statusCode==200){
        print('Login Response: ${response.data}');

        final user=UserModel.fromJson(response.data);

        final token=response.data['token'];

        if(token!=null){
          await sharedPreferences.setString(AppConstants.TOKEN, token);
          dioClient.updateHeader(token);       
        }
        return user.role=='USER';
      }else{
        print('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking approval (AuthRepo): $e');
      return false;
}
}
}