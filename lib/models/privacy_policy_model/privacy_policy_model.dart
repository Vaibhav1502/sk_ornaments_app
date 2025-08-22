import 'dart:convert';

// Helper function to decode the JSON string
PrivacyPolicyResponse privacyPolicyResponseFromJson(String str) => PrivacyPolicyResponse.fromJson(json.decode(str));

// This class models the entire API response
class PrivacyPolicyResponse {
  final String status;
  final PrivacyPolicyData? data;

  PrivacyPolicyResponse({
    required this.status,
    this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) => PrivacyPolicyResponse(
    status: json["status"] ?? "error",
    data: json["data"] != null ? PrivacyPolicyData.fromJson(json["data"]) : null,
  );
}

// This class models the nested 'data' object
class PrivacyPolicyData {
  final String title;
  final String content;
  final String lastUpdated;

  PrivacyPolicyData({
    required this.title,
    required this.content,
    required this.lastUpdated,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) => PrivacyPolicyData(
    title: json["title"] ?? "No Title",
    content: json["content"] ?? "No content available.",
    lastUpdated: json["last_updated"] ?? "Not specified",
  );
}