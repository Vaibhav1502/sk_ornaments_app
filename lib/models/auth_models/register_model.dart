import 'dart:convert';

import 'login_model.dart';


// Helper function to decode the JSON string
RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

class RegisterResponse {
  final String status;
  final String message;
  final RegisterData? data;

  RegisterResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
    data: json["data"] != null ? RegisterData.fromJson(json["data"]) : null,
  );
}

class RegisterData {
  final User user;
  final String token;

  RegisterData({
    required this.user,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
    user: User.fromJson(json["user"] ?? {}),
    token: json["token"] ?? "",
  );
}