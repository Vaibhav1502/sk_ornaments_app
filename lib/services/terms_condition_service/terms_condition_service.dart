import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/terms_conditions_model/terms_conditions_model.dart';


class Policy {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  /// Fetches the Terms and Conditions from the API.
  ///
  /// Returns a [TermsConditionsData] object on success.
  /// Throws an [Exception] if the request fails or the data is invalid.
  static Future<TermsConditionsData> fetchTermsConditions() async {
    final url = Uri.parse('$_baseUrl/terms-conditions');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the entire JSON response from the server.
        final decodedBody = json.decode(response.body);

        // Check the API's internal status and ensure 'data' is not null.
        if (decodedBody['status'] == 'success' && decodedBody['data'] != null) {
          // If successful, parse the 'data' object using the model's factory.
          return TermsConditionsData.fromJson(decodedBody['data']);
        } else {
          // Throw an exception if the API reports an error.
          throw Exception('Failed to parse terms and conditions data.');
        }
      } else {
        // Throw an exception for non-200 server responses (e.g., 404, 500).
        throw Exception('Failed to load terms and conditions. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any other errors (e.g., network issues, parsing errors) and rethrow.
      throw Exception('An error occurred while fetching terms and conditions: $e');
    }
  }
}