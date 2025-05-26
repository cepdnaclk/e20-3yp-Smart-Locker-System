class LockerLogsModel {
  final int id;
  final String dateTime;
  final String status;
  final int clusterId;

  LockerLogsModel({
    required this.id,
    required this.dateTime,
    required this.status,
    required this.clusterId,
  });
  factory LockerLogsModel.fromJson(Map<String, dynamic> json) {
    return LockerLogsModel(
      id: json['id'],
      dateTime: json['date_time'],
      status: json['status'],
      clusterId: json['cluster_id'],
    );
  }

  Map<String, dynamic>toJson(){
    return {
      'id': id,
      'date_time': dateTime,
      'status': status,
      'cluster_id': clusterId,
    };
  }
}