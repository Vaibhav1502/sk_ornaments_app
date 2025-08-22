// lib/services/product_detail_service/product_detail_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product_detail_model/product_detail_model.dart';

class ProductDetailService {
  static Future<ProductDetail> fetchProductDetail(int id) async {
    final url = Uri.parse("https://staging.skornaments.com/api/v1/products/$id");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 1. Decode the entire response body
        final Map<String, dynamic> decodedBody = json.decode(response.body);

        // 2. Extract the 'data' object, which contains both 'product' and 'pricing_breakup'
        final Map<String, dynamic> apiData = decodedBody['data'];

        // 3. Pass the 'apiData' object to the factory.
        //    The factory will correctly find 'product' and 'pricing_breakup' inside it.
        return ProductDetail.fromJson(apiData);

      } else {
        // Throw a more informative error
        throw Exception("Failed to load product details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Catch network or parsing errors and rethrow
      throw Exception("An error occurred while fetching product details: $e");
    }
  }
}