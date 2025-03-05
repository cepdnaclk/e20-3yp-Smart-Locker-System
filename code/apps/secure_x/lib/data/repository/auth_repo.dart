import 'package:get/get.dart';
import 'package:secure_x/data/api/api_client.dart';
import 'package:secure_x/models/create_user_model.dart';
import 'package:secure_x/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  }
  );

  Future<Response> registration(CreateUserModel createUserModel) async {
    return await apiClient.postData(AppConstants.CREATE_USER_URI, createUserModel.toJason());
  }

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(AppConstants.LOG_IN_URI, {'email':email,'password':password});
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token=token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  bool isUserSignedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  void getUserToken() {
    String token = sharedPreferences.getString(AppConstants.TOKEN) ?? 'None';
    // save in memory
    apiClient.token = token;
    apiClient.updateHeader(token);
  }

  void clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    apiClient.token = '';
    apiClient.updateHeader('');
  }


}