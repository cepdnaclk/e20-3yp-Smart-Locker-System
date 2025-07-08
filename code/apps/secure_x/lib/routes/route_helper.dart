import 'package:get/get.dart';
import 'package:secure_x/pages/change_password.dart';
import 'package:secure_x/pages/create_user.dart';
import 'package:secure_x/pages/locker_logs.dart';
import 'package:secure_x/pages/log_in.dart';
import 'package:secure_x/pages/login_success.dart';
import 'package:secure_x/pages/navigation.dart';
import 'package:secure_x/pages/notifications.dart';
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
  ];
}