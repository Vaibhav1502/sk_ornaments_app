import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/add_to_cart_model/add_to_cart_model.dart';


class CartService {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  // Method to add a product to the cart
  static Future<AddToCartResponse> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final url = Uri.parse('$_baseUrl/cart/add');

    // The body of the request, matching your raw data
    final Map<String, dynamic> requestBody = {
      "product_id": productId,
      "quantity": quantity,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          // Add any Authorization headers if needed, e.g.,
          // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
        body: json.encode(requestBody), // Encode the map to a JSON string
      );

      // Decode the response body
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        // If the server returns a 200 OK response, parse the JSON.
        return AddToCartResponse.fromJson(responseBody);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception with the message from the API.
        throw Exception(responseBody['message'] ?? 'Failed to add product to cart.');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('An error occurred: $e');
    }
  }
}