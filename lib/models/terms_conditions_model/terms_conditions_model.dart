import 'dart:convert';

// Helper function to decode the JSON string
TermsConditionsResponse termsConditionsResponseFromJson(String str) => TermsConditionsResponse.fromJson(json.decode(str));

// This class models the entire API response
class TermsConditionsResponse {
  final String status;
  final TermsConditionsData? data;

  TermsConditionsResponse({
    required this.status,
    this.data,
  });

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) => TermsConditionsResponse(
    status: json["status"] ?? "error",
    data: json["data"] != null ? TermsConditionsData.fromJson(json["data"]) : null,
  );
}

// This class models the nested 'data' object
class TermsConditionsData {
  final String title;
  final String content;
  final String lastUpdated;

  TermsConditionsData({
    required this.title,
    required this.content,
    required this.lastUpdated,
  });

  factory TermsConditionsData.fromJson(Map<String, dynamic> json) => TermsConditionsData(
    title: json["title"] ?? "No Title",
    content: json["content"] ?? "No content available.",
    lastUpdated: json["last_updated"] ?? "Not specified",
  );
}