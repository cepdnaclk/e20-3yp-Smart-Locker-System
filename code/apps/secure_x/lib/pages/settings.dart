import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/pages/change_password.dart';
import 'package:secure_x/pages/user_details.dart';
import 'package:secure_x/utils/appcolors.dart';
import 'package:secure_x/utils/custom_app_bar.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget{
  @override
  Widget build(BuildContext context){
  
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
      child: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General',style: TextStyle(color: AppColors.appBarColor),),
            tiles:[
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text('Account',style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: (context){
                  Get.to(() => UserDetails());
                },
              ),
              /*SettingsTile.switchTile(
                initialValue:false, 
                onToggle: (bool value){
      
                }, 
                title: Text('Dark Mode'),
                )*/
            ]
            ),
            SettingsSection(
              title: Text('Notifications',style: TextStyle(color: AppColors.appBarColor),),
              tiles: [
                SettingsTile.switchTile(
                  activeSwitchColor: AppColors.buttonBackgroundColor2,
                  initialValue: true, 
                  leading: Icon(Icons.notifications),
                  onToggle: (bool value){
      
                  }, 
                  title: Text('Enable Notifications',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                /*SettingsTile.switchTile(
                  initialValue: false, 
                  leading: Icon(Icons.email),
                  onToggle: (bool value){
      
                  }, 
                  title:Text('Email Alerts'),
                ),
                SettingsTile.switchTile(
                  initialValue: false, 
                  leading: Icon(Icons.sms),
                  onToggle: (bool value){
      
                  }, 
                  title: Text('SMS Alerts'),
                ),*/
              ],
            ),
            SettingsSection(
              title: Text('Security',style: TextStyle(color: AppColors.appBarColor),),
              tiles: [
                SettingsTile.navigation(
                  title: Text('Change Password',style: TextStyle(fontWeight: FontWeight.bold),),
                  leading: Icon(Icons.lock),  
                  onPressed: (context) {
                    Get.to(() => ChangePassword());
                  },
                )
              ],
          ),
          SettingsSection(
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text('Log out',
                style: TextStyle(
                  color: AppColors.textHighlight,
                  fontWeight: FontWeight.bold,
                ),
                ),
                onPressed:(context)async{
                  bool? confirm=await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Log out'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(result: false);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(result: true);
                          },
                          child: Text('Log out'),
                        ),
                      ],
                    ),
                  );
                  if(confirm==true){
                    AuthController authController = Get.find<AuthController>();
                    authController.logout(context);
                  }
                }
                )
            ]
          )
        ],
      ),
    ));

  }
}