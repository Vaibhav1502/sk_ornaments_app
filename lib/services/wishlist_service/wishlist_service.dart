import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/wishlist_model/wishlist_model.dart';


class WishlistService {
  static const String _baseUrl = "https://staging.skornaments.com/api/v1";

  /// Adds a product to the user's wishlist.
  static Future<AddToWishlistResponse> addToWishlist({required int productId}) async {
    final url = Uri.parse('$_baseUrl/wishlist/add');
    final requestBody = {"product_id": productId};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode(requestBody),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        return AddToWishlistResponse.fromJson(responseBody);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to add item to wishlist.');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Fetches all items from the user's wishlist.
  static Future<List<WishlistItem>> fetchWishlist() async {
    final url = Uri.parse('$_baseUrl/wishlist');

    try {
      final response = await http.get(url, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final wishlistResponse = wishlistResponseFromJson(response.body);
        if (wishlistResponse.status == 'success' && wishlistResponse.data != null) {
          return wishlistResponse.data!.items;
        } else {
          throw Exception(wishlistResponse.message);
        }
      } else {
        throw Exception('Failed to load wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

// You would also add a 'removeFromWishlist' method here in the future
}