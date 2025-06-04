import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:secure_x/controllers/locker_controller.dart';
import 'package:secure_x/models/locker_cluster_model.dart';
import 'package:secure_x/utils/appcolors.dart';

class LockerMap extends StatefulWidget {
  const LockerMap({super.key});

  @override
  State<LockerMap> createState() => _LockerMapState();

}

class _LockerMapState extends State<LockerMap> {
  final LockerController lockerController=Get.find<LockerController>();

  @override
  void initState(){
    super.initState();
    lockerController.fetchAllLockerClusters();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const CustomAppBar(),
      body:content(),
    );
  }

  Widget content(){
    return FlutterMap(
      options:const MapOptions(
        initialCenter: LatLng(7.256197072872723, 80.59694481740117),
        initialZoom: 11,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all,
        )
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: lockerController.lockerClusters
            .where((cluster) => cluster.availableNumberOfLockers > 0)
            .map((cluster) => Marker(
              point: LatLng(cluster.latitude, cluster.longitude),
              width: 120.w,
              height: 90.h,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w, 
                      vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 3.r),
                      ],
                    ),
              child: Text(
                cluster.clusterName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () {
                _showLockerDetails(context, cluster);
              },
              child: Icon(
                Icons.location_on,
                size: 38.sp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ))
                .toList(),
          ),        
      ],
    );
  }

  void _showLockerDetails(BuildContext context, LockerClusterModel cluster) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3.h,  
          minChildSize: 0.2.h,
          maxChildSize: 0.4.h,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16.h,
                right: 16.h,
                top: 24.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 30.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    cluster.clusterName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Total Lockers: ${cluster.totalNumberOfLockers}",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Available Lockers: ${cluster.availableNumberOfLockers}",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 6.h,
                        foregroundColor: AppColors.buttonBackgroundColor1,
                        backgroundColor: AppColors.buttonForegroundColor1,
                      ),
                      onPressed: () {
                        //locker reservation not done yet
                      },
                      child: Text("Reserve Locker",style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

TileLayer get openStreetMapTileLayer=> TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 
  userAgentPackageName: 'dev.fleafleft.flutter_map.example',
);