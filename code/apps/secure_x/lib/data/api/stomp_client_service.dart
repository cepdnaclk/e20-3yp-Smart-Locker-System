import 'dart:convert';
import 'package:get/get.dart';
import 'package:secure_x/controllers/notification_controller.dart';
import 'package:secure_x/utils/custom_snackbar.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompClientService {
  late StompClient _stompClient;
  bool _isConnected=false;

  void connect(String userId){
    _stompClient=StompClient(
      config: StompConfig.sockJS(
        url: 'https://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/ws-notifications',
        onConnect: (StompFrame frame){
          _isConnected=true;
          print('Connected to WebSocket as $userId');

          _stompClient.subscribe(
            destination: '/topic/notifications/$userId', 

            callback: (StompFrame frame){
              final data=jsonDecode(frame.body!);
              print('Notification : ${data['title']} - ${data['message']}');
              CustomSnackBar.show(
                context: Get.context!, 
                message: data['message'] ?? 'You have a new notification',
                title: data['title']?? 'Notification',
                isError: false,
              );
              /*FlutterLocalNotificationsPlugin().show(
                0,
                data['title'],
                data['message'],
                NotificationDetails(
              android: AndroidNotificationDetails('channelId', 'SmartLocker Alerts'),
  ),
);*/


        NotificationController.to.addNotification(data);
            },
);
        },
        onDisconnect: (_){
          _isConnected=false;
          print('Disconnected from webSocket');
        },
        onWebSocketError: (dynamic error){
          print('WebSocket error : $error');
        },
        onStompError: (StompFrame frame){
          print('Stomp Error : ${frame.body}');
        },
        onUnhandledMessage: (frame){
          print('Unhandled message : ${frame.body}');
        },
        reconnectDelay: const Duration(seconds: 5),
      ),
    );
    _stompClient.activate();

  void disconnect(){
    if(_isConnected){
      _stompClient.deactivate();
      print('Disconnected from WebSocket');
    }
  }
  }
}