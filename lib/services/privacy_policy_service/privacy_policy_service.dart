import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/privacy_policy_model/privacy_policy_model.dart';


class PrivacyPolicyService {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  /// Fetches the Privacy Policy from the API.
  ///
  /// Returns a [PrivacyPolicyData] object on success.
  /// Throws an [Exception] if the request fails or the data is invalid.
  static Future<PrivacyPolicyData> fetchPrivacyPolicy() async {
    final url = Uri.parse('$_baseUrl/privacy-policy');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        if (decodedBody['status'] == 'success' && decodedBody['data'] != null) {
          return PrivacyPolicyData.fromJson(decodedBody['data']);
        } else {
          throw Exception('Failed to parse privacy policy data.');
        }
      } else {
        throw Exception('Failed to load privacy policy. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching the privacy policy: $e');
    }
  }
}