import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
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

            // Sort logs by accessTime descending (newest first)
            logs.sort((a, b) =>
              DateTime.parse(b.accessTime).compareTo(DateTime.parse(a.accessTime)));
              
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];

                // Parse and format accessTime
                String formattedAccessTime = '';
                if (log.accessTime != null && log.accessTime.isNotEmpty) {
                  try {
                    final accessTime = DateTime.parse(log.accessTime);
                    formattedAccessTime = DateFormat('yyyy-MM-dd ; HH:mm:ss').format(accessTime);
                  } catch (e) {
                    formattedAccessTime = log.accessTime; // fallback
                  }
                }

                // Parse and format releasedTime
                String formattedReleasedTime = '';
                if (log.releasedTime != null && log.releasedTime.isNotEmpty) {
                  try {
                    final releasedTime = DateTime.parse(log.releasedTime);
                    formattedReleasedTime = DateFormat('yyyy-MM-dd ; HH:mm:ss').format(releasedTime);
                  } catch (e) {
                    formattedReleasedTime = log.releasedTime; // fallback
                  }
                }
  
                return Card(
                  margin: EdgeInsets.all(8.h),
                  child: ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text('Status: ${log.status ?? "N/A"}'),
                    subtitle: Text(
                      'Accessed: ${formattedAccessTime}\n'
                      'Released: ${formattedReleasedTime}\n'
                      'Location: ${log.location}\n'
                      'Locker ID: ${log.lockerId}'
                  ),
                )
                );
              },
            );
          }
        },
      ),
    );    
  }
}