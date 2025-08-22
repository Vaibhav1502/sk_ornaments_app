import 'dart:convert';

// Helper function to decode the JSON string
ReturnPolicyResponse returnPolicyResponseFromJson(String str) => ReturnPolicyResponse.fromJson(json.decode(str));

// This class models the entire API response
class ReturnPolicyResponse {
  final String status;
  final ReturnPolicyData? data;

  ReturnPolicyResponse({
    required this.status,
    this.data,
  });

  factory ReturnPolicyResponse.fromJson(Map<String, dynamic> json) => ReturnPolicyResponse(
    status: json["status"] ?? "error",
    data: json["data"] != null ? ReturnPolicyData.fromJson(json["data"]) : null,
  );
}

// This class models the nested 'data' object
class ReturnPolicyData {
  final String title;
  final String content;
  final String returnPeriod;
  final String conditions;

  ReturnPolicyData({
    required this.title,
    required this.content,
    required this.returnPeriod,
    required this.conditions,
  });

  factory ReturnPolicyData.fromJson(Map<String, dynamic> json) => ReturnPolicyData(
    title: json["title"] ?? "No Title",
    content: json["content"] ?? "No content available.",
    returnPeriod: json["return_period"] ?? "Not specified",
    conditions: json["conditions"] ?? "Not specified",
  );
}