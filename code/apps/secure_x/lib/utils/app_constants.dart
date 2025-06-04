class AppConstants {
  static const String APP_NAME='Securex';

  //static const String BASE_URL='http://192.168.8.185:9090';
  //static const String BASE_URL='http://10.0.2.2:9090';
  static const String BASE_URL='https://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net';


  static const String TOKEN = "token";

  static const String LOG_IN_URI = '/api/v1/login';
  static const String CREATE_USER_URI = '/api/v1/newUsers/register';
  static const String USER_INFO_URI='/api/v1/user/profile';
  static const String UNLOCK_LOCKER_URI='/api/v1/user/unlockLocker';
  static const String LOCKER_LOGS_URI='/api/v1/user/lockerLogs';
  static const String EDIT_PROFILE_URI='/api/v1/user/editProfile';
  static const String ACCESS_LOCKER_URI='/api/v1/user/accessLocker';
  static const String UNASSIGN_LOCKER_URI='/api/v1/user/unassign';
  static const String GET_OTP_CODE_URI='/api/v1/user/getOtpCode';
  static const String GENERATE_NEW_OTP_CODE_URI='/api/v1/user/generateNewOtpCode';
  static const String LOCKER_AVAILABILITY_URI='/api/v1/user/lockerAvailability/{clusterId}';
}