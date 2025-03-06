class ResponseModel<T> {
  final bool isSuccess;
  final String message;
  final T? data; // Generic data field

  ResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  // Optional: Add a factory constructor to parse JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ResponseModel<T>(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}