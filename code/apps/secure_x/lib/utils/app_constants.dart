class AppConstants {
  static const String APP_NAME='Securex';

  //static const String BASE_URL='http://192.168.8.185:8080';
  static const String BASE_URL='http://10.0.2.2:9191';
  //static const String BASE_URL='http://localhost:8080';

  static const String TOKEN = "token";

  static const String LOG_IN_URI = '/api/v1/login';
  static const String CREATE_USER_URI = '/api/v1/newUsers/register';
  static const String USER_INFO_URI='/api/v1/user/profile';
  static const String UNLOCK_LOCKER_URI='/api/v1/user/unlockLocker';
  static const String LOCKER_LOGS_URI='/api/v1/user/lockerLogs';
}