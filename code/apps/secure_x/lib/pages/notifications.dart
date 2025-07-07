import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:secure_x/controllers/notification_controller.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: CustomAppBar(),
        body: Obx((){
          final list=NotificationController.to.notifications;

          if(list.isEmpty){
            return Center(
              child: Text('No notifications'),);
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_ ,index){
              final item=list[index];
              return Card(
                child: ListTile(
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(item['message']?? ''),
                  trailing: Text(item['type']?? 'INFO'),
                ),
              );
            },
          );
        }),
      );
  }
}