import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/contact_model/contact_model.dart';


class ContactService {
  static const String apiUrl = "https://staging.skornaments.com/api/v1/contact";

  static Future<ContactModel?> fetchContactDetails() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ContactModel.fromJson(data['data']);
      }
    } catch (e) {
      print("Error fetching contact details: $e");
    }
    return null;
  }
}
