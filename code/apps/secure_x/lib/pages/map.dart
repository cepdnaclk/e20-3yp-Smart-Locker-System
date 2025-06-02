import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:secure_x/models/locker_location_model.dart';
import 'package:secure_x/utils/appcolors.dart';

class LockerMap extends StatefulWidget {
  const LockerMap({super.key});

  @override
  State<LockerMap> createState() => _LockerMapState();

}

class _LockerMapState extends State<LockerMap> {
  // Locker location model
  final List<LockerLocation> lockerLocations = [
    LockerLocation(
      latitude: 7.256197072872723, 
      longitude: 80.59694481740117,
      availableLockers: 3,
      locationName: "University Gymnasium",
    ),
    LockerLocation(
      latitude: 7.254865694625847,
      longitude: 80.5913351662026,
      availableLockers: 6,
      locationName: "Department of Computer Engineering",
    ),
    LockerLocation(
      latitude: 7.254977079844001, 
      longitude: 80.59168620853136,
      availableLockers: 5,
      locationName: "Department of Electrical and Electronic Engineering",
    ),
    
    LockerLocation(
      latitude: 7.256562860725244, 
      longitude: 80.59596701367326 ,
      availableLockers: 2,
      locationName: "Information Technology Center",
    ),
  ];

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
          markers: lockerLocations
            .where((location) => location.availableLockers > 0)
            .map((location) => Marker(
              point: LatLng(location.latitude, location.longitude),
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
                location.locationName,
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
                _showLockerDetails(context, location);
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

  void _showLockerDetails(BuildContext context, LockerLocation location) {
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
                  location.locationName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Available Lockers: ${location.availableLockers}",
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