class LockerClusterModel {
  final int? id;
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
      id: json['id'] as int? ?? 0,
      clusterName: json['clusterName'] as String? ?? '',
      lockerClusterDescription: json['lockerClusterDescription'] as String? ?? '',
      totalNumberOfLockers: json['totalNumberOfLockers'] as int? ?? 0 ,
      availableNumberOfLockers: json['availableNumberOfLockers'] as int? ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble()?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'clusterName': clusterName,
      'lockerClusterDescription': lockerClusterDescription,
      'totalNumberOfLockers': totalNumberOfLockers,
      'availableNumberOfLockers': availableNumberOfLockers,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
