import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/product_model/product_model.dart';

class ProductService {
  static const String baseUrl = "https://staging.skornaments.com/api/v1/products";

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> productsJson = jsonData['data']['products'];

        return productsJson.map((p) => Product.fromJson(p)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
