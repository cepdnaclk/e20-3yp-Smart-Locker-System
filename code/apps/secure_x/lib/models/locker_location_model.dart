class LockerLocation {
  final double latitude;
  final double longitude;
  final int availableLockers;
  final String locationName;

  LockerLocation({
    required this.latitude,
    required this.longitude,
    required this.availableLockers,
    required this.locationName,
  });

  // Optional: Add fromJson/toJson if you're getting data from an API
  factory LockerLocation.fromJson(Map<String, dynamic> json) {
    return LockerLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      availableLockers: json['availableLockers'],
      locationName: json['locationName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'availableLockers': availableLockers,
      'locationName': locationName,
    };
  }
}
