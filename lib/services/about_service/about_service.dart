import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/about_model/abou_model.dart';

class AboutService {
  final String _url = "https://staging.skornaments.com/api/v1/about";

  Future<AboutData> fetchAboutData() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return AboutData.fromJson(jsonData['data']);
    } else {
      throw Exception("Failed to load About Us data");
    }
  }
}