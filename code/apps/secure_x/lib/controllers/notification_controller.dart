import 'package:get/get.dart';

class NotificationController extends GetxController{
  final notifications=<Map<String, dynamic>>[].obs;

  void addNotification(Map<String, dynamic>data){
    notifications.insert(0, data);
  }

  static NotificationController get to=> Get.find<NotificationController>();
}