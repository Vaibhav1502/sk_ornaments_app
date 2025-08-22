import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/return_policy_model/return_policy_model.dart';


class ReturnPolicyService {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  /// Fetches the Return Policy from the API.
  ///
  /// Returns a [ReturnPolicyData] object on success.
  /// Throws an [Exception] if the request fails or the data is invalid.
  static Future<ReturnPolicyData> fetchReturnPolicy() async {
    final url = Uri.parse('$_baseUrl/return-policy');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        if (decodedBody['status'] == 'success' && decodedBody['data'] != null) {
          return ReturnPolicyData.fromJson(decodedBody['data']);
        } else {
          throw Exception('Failed to parse return policy data.');
        }
      } else {
        throw Exception('Failed to load return policy. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching the return policy: $e');
    }
  }
}