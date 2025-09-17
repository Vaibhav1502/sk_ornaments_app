import 'dart:convert';
import 'login_model.dart'; // Reusing the powerful User model

// Helper function to decode the JSON string
ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

class ProfileResponse {
  final String status;
  final String message;
  final ProfileData? data;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
    data: json["data"] != null ? ProfileData.fromJson(json["data"]) : null,
  );
}

class ProfileData {
  final User user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    user: User.fromJson(json["user"] ?? {}),
  );
}