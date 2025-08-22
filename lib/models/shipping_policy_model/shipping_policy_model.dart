import 'dart:convert';

// Helper function to decode the JSON string
ShippingPolicyResponse shippingPolicyResponseFromJson(String str) => ShippingPolicyResponse.fromJson(json.decode(str));

// This class models the entire API response
class ShippingPolicyResponse {
  final String status;
  final ShippingPolicyData? data;

  ShippingPolicyResponse({
    required this.status,
    this.data,
  });

  factory ShippingPolicyResponse.fromJson(Map<String, dynamic> json) => ShippingPolicyResponse(
    status: json["status"] ?? "error",
    data: json["data"] != null ? ShippingPolicyData.fromJson(json["data"]) : null,
  );
}

// This class models the nested 'data' object
class ShippingPolicyData {
  final String title;
  final String content;
  final String deliveryTime;
  final String shippingCost;

  ShippingPolicyData({
    required this.title,
    required this.content,
    required this.deliveryTime,
    required this.shippingCost,
  });

  factory ShippingPolicyData.fromJson(Map<String, dynamic> json) => ShippingPolicyData(
    title: json["title"] ?? "No Title",
    content: json["content"] ?? "No content available.",
    deliveryTime: json["delivery_time"] ?? "Not specified",
    shippingCost: json["shipping_cost"] ?? "Not specified",
  );
}