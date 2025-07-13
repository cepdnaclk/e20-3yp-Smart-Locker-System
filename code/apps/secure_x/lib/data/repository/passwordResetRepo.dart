import 'package:dio/dio.dart';
import 'package:secure_x/utils/app_constants.dart';

class PasswordResetRepo {
  final Dio dio;

  PasswordResetRepo({required this.dio});

  //generate otp for password reset
  Future<Response> generateOtp(String identifier) async{
    return await dio.post(AppConstants.GENERATE_OTP_TO_RESET_PASSWORD,
    queryParameters: {'identifier':identifier},
    );
  }

  /*//validate otp code
  Future<Response> validateOtp(String username, String otp) async{
    return await dio.post(
      AppConstants.VALIDATE_OTP_TO_RESET_PASSWORD,
      data: {
        'username':username,
        'otp':otp,
      },
    );
  }*/

  //update password with otp
  Future<Response> updatePassword({
    required String usernameOrEmail,
    required String newPassword,
    required String otp,
  }) async{
    final payload={
      'usernameOrEmail': usernameOrEmail,
      'newPassword': newPassword,
      'otp': otp,
    };
    print('Password update payload : $payload');
    return await dio.post(
      AppConstants.UPDATE_PASSWORD,
      data:{
        'usernameOrEmail': usernameOrEmail,
        'newPassword':newPassword,
        'otp':otp,
      },
    );
  }
  
}