import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:secure_x/models/locker_location_model.dart';

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
      options: MapOptions(
        initialCenter: LatLng(7.256197072872723, 80.59694481740117),
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
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
              width: 100,
              height: 80,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 3),
                      ],
                    ),
              child: Text(
                location.locationName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                _showLockerDetails(context, location);
              },
              child: const Icon(
                Icons.location_on,
                size: 36,
                color: Colors.green,
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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,  // Start at 30% height (adjust as needed)
        minChildSize: 0.2,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24, // Adjust for keyboard
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  location.locationName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Available Lockers: ${location.availableLockers}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Trigger locker reservation
                    },
                    child: const Text("Reserve Locker"),
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
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
  userAgentPackageName: 'dev.fleafleft.flutter_map.example',
);