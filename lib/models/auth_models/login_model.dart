import 'dart:convert';

// Helper function to decode the JSON string
LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  final String status;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
    data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
  );
}

class LoginData {
  final User user;
  final String token;

  LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    user: User.fromJson(json["user"] ?? {}),
    token: json["token"] ?? "",
  );
}

class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? address;
  final String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.address,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"] ?? "Unknown User",
    email: json["email"] ?? "No email",
    role: json["role"],
    address: json["address"],
    phone: json["phone"],
  );
}