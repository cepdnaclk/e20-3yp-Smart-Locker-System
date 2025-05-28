import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:secure_x/controllers/auth_controller.dart';
import 'package:secure_x/models/locker_logs_model.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class LockerLogs extends StatelessWidget {
  final AuthController authController=Get.find<AuthController>();

  LockerLogs({super.key});

  @override
  Widget build(BuildContext context){
    authController.getUserLogs();
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<LockerLogsModel>>(
        future: authController.getUserLogs(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No logs found.'));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text('Status: ${log.status}'),
                    subtitle: Text('Date: ${log.dateTime}\nCluster: ${log.clusterId}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );    
  }
}