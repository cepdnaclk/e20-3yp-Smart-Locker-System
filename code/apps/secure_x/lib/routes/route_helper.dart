/*import 'package:get/get.dart';
import 'package:secure_x/pages/change_password.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/pages/notifications.dart';
import 'package:secure_x/pages/reset_password.dart';
import 'package:secure_x/pages/settings.dart';
import 'package:secure_x/pages/sign_in.dart';
import 'package:secure_x/pages/splash_screen.dart';
import 'package:secure_x/pages/unlock.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/pages/user_details.dart';
import 'package:secure_x/pages/edit_profile.dart';

class RouteHelper {
  //static const String initial='/';
  static const String splashScreen='/splash-screen';
  static const String login='/log-in';
  static const String createUser='/create-user';
  static const String loginSuccess='/login-success';
  static const String unlock='/unlock';
  static const String signin='/sign-in';
  static const String user='/user';
  static const String navigation='/navigation';
  static const String userDetails='/user-details';
  static const String lockerLogs='/locker-logs';
  static const String editProfile='/edit-profile';
  static const String notifications='/notifications';
  static const String settings='/settings';
  static const String changePassword='/change-password';
  static const String resetPassword='/reset-password';

  //static String getInitial()=>'$initial';
  static String getSplashScreen()=>'$splashScreen';
  static String getlogin()=>'$login';
  static String getCreateuser()=>'$createUser';
  static String getLoginSuccess()=>'$loginSuccess';
  static String getUnlock()=>'$unlock';
  static String getSignin()=>'$signin';
  static String getUser()=>'$user';
  static String getNavigation()=>'$navigation';
  static String getUserDetails()=>'$userDetails';
  static String getLockerLogs()=>'$lockerLogs';
  static String getEditProfile()=>'$editProfile';
  static String getNotifications()=>'$notifications';
  static String getSettings()=>'$settings';
  static String getChangePassword()=>'$ChangePassword';
  static String getResetPassword()=>'$resetPassword';

  static List<GetPage> routes=[
    //GetPage(name:initial,page:()=>Navigation()),
    GetPage(name: splashScreen,page: () => SplashScreen(),),
    GetPage(name: login,page: ()=>LogIn()),
    GetPage(name: createUser,page: () => CreateUser(),),
    GetPage(name: loginSuccess,page: () => LoginSuccess(),),
    GetPage(name: unlock, page:() => Unlock(),),
    GetPage(name: signin, page:()=>SignIn()),
    GetPage(name: user, page: ()=>User()),
    GetPage(name: navigation, page: ()=>Navigation()),    
    GetPage(name: userDetails,page:()=> UserDetails(),),
    GetPage(name: lockerLogs,page: ()=> LockerLogs(),),
    GetPage(name: editProfile,page: ()=>EditProfile(),),
    GetPage(name: notifications,page: ()=>Notifications(),),
    GetPage(name: settings,page: ()=>Settings(),),
    GetPage(name: changePassword,page: ()=>ChangePassword(),),
    GetPage(name: resetPassword,page: ()=>ResetPassword()),
  ];
}*/

import 'package:get/get.dart';
import 'package:secure_x/pages/change_password.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/pages/find.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/pages/notifications.dart';
import 'package:secure_x/pages/reset_password.dart';
import 'package:secure_x/pages/settings.dart';
import 'package:secure_x/pages/sign_in.dart';
import 'package:secure_x/pages/splash_screen.dart';
import 'package:secure_x/pages/unlock.dart';
import 'package:secure_x/pages/user.dart';
import 'package:secure_x/pages/user_details.dart';
import 'package:secure_x/pages/edit_profile.dart';

class RouteHelper {
  static const String splashScreen = '/splash-screen';
  static const String login = '/log-in';
  static const String signin='/sign-in';
  static const String createUser = '/create-user';
  static const String navigation = '/navigation';
  static const String userDetails = '/user-details';
  static const String lockerLogs = '/locker-logs';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String resetPassword = '/reset-password';
  static const String unlock='/unlock';
  static const String find='/find';
  static const String user='/user';

  static String getSplashScreen() => '$splashScreen';
  static String getLogin() => '$login';
  static String getSignin()=> '$signin';
  static String getCreateUser() => '$createUser';
  static String getNavigation() => '$navigation';
  static String getUserDetails() => '$userDetails';
  static String getLockerLogs() => '$lockerLogs';
  static String getEditProfile() => '$editProfile';
  static String getNotifications() => '$notifications';
  static String getSettings() => '$settings';
  static String getChangePassword() => '$changePassword';
  static String getResetPassword() => '$resetPassword';
  static String getUnlock()=>'$unlock';
  static String getFind()=>'$find';
  static String getUser()=>'$user';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: login, page: () => LogIn()),
    GetPage(name: signin, page: () => SignIn()),
    GetPage(name: createUser, page: () => CreateUser()),
    // Main navigation shell
    GetPage(name: navigation, page: () => Navigation()),
    // Subpages wrapped in Navigation to keep bottom nav bar visible
    GetPage(name: userDetails, page: () => Navigation(child: UserDetails())),
    GetPage(name: lockerLogs, page: () => Navigation(child: LockerLogs())),
    GetPage(name: editProfile, page: () => Navigation(child: EditProfile())),
    GetPage(name: notifications, page: () => Navigation(child: Notifications())),
    GetPage(name: settings, page: () => Navigation(child: Settings())),
    GetPage(name: changePassword, page: () => Navigation(child: ChangePassword())),
    GetPage(name: resetPassword, page: () => Navigation(child: ResetPassword())),
    GetPage(name: unlock, page: () => Navigation(child: Unlock())),
    GetPage(name: find, page: () => Navigation(child: Find())),
    GetPage(name: user, page: () => Navigation(child: User())),
  ];
}
