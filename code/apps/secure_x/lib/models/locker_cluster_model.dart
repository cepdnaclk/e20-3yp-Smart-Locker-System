class LockerClusterModel {
  final int id;
  final String clusterName;
  final String lockerClusterDescription;
  final int totalNumberOfLockers;
  final int availableNumberOfLockers;
  final double latitude;
  final double longitude;

  LockerClusterModel({
    required this.id,
    required this.clusterName,
    required this.lockerClusterDescription,
    required this.totalNumberOfLockers,
    required this.availableNumberOfLockers,
    required this.latitude,
    required this.longitude,
  });

  // Optional: Add fromJson/toJson if you're getting data from an API
  factory LockerClusterModel.fromJson(Map<String, dynamic> json) {
    return LockerClusterModel(
      id: json['id'],
      clusterName: json['lockerClusterName'],
      lockerClusterDescription: json['lockerClusterDescription'],
      totalNumberOfLockers: json['totalNumberOfLockers'],
      availableNumberOfLockers: json['availableNumberOfLockers'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'lockerClusterName': clusterName,
      'lockerClusterDescription': lockerClusterDescription,
      'totalNumberOfLockers': totalNumberOfLockers,
      'availableNumberOfLockers': availableNumberOfLockers,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
