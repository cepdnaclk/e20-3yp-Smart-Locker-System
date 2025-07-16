class LockerLogsModel {
  final int id;
  final String accessTime;
  final String releasedTime;
  final String? status;
  final String location;
  final int lockerId;

  LockerLogsModel({
    required this.id,
    required this.accessTime,
    required this.releasedTime,
    this.status,
    required this.location,
    required this.lockerId,
  });
  factory LockerLogsModel.fromJson(Map<String, dynamic> json) {
    return LockerLogsModel(
      id: json['logId'],
      accessTime: json['accessTime'],
      releasedTime: json['releasedTime']?? '',
      status: json['status'],
      location: json['location'],
      lockerId: json['lockerId'],
    );
  }

  Map<String, dynamic>toJson(){
    return {
      'logId': id,
      'accessTime': accessTime,
      'releasedTime': releasedTime,
      'status': status,
      'location':location,
      'lockerId': lockerId,
    };
  }
}