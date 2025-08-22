import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/shipping_policy_model/shipping_policy_model.dart';


class PolicyService {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  // Method to fetch the shipping policy
  static Future<ShippingPolicyData> fetchShippingPolicy() async {
    final url = Uri.parse('$_baseUrl/shipping-policy');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        // Check for API-level success status
        if (decodedBody['status'] == 'success' && decodedBody['data'] != null) {
          return ShippingPolicyData.fromJson(decodedBody['data']);
        } else {
          throw Exception('Failed to parse shipping policy data.');
        }
      } else {
        // Handle server errors
        throw Exception('Failed to load shipping policy. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('An error occurred: $e');
    }
  }
}