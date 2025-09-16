import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth_models/login_model.dart';
import '../storage/token_storage_service.dart';

class AuthService {
  // IMPORTANT: For Android Emulator, use 10.0.2.2 to refer to your computer's localhost.
  // For iOS Simulator, '127.0.0.1' or 'localhost' is fine.
  static const String _baseUrl = "http://10.0.2.2:8000/api/v1";

  static final TokenStorageService _tokenStorage = TokenStorageService();

  /// Logs in the user and securely stores the token.
  /// Returns the User object on success.
  static Future<User> login({required String email, required String password}) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        final loginData = LoginData.fromJson(responseBody['data']);

        // Check if token exists before saving
        if (loginData.token.isNotEmpty) {
          await _tokenStorage.saveToken(loginData.token);
          return loginData.user;
        } else {
          throw Exception('Login successful, but no token was provided.');
        }
      } else {
        throw Exception(responseBody['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      // Re-throw the exception to be handled by the UI
      rethrow;
    }
  }

  /// Logs out the user by deleting the token.
  static Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  /// Checks if a token exists to determine if the user is logged in.
  static Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getToken();
    return token != null;
  }
}