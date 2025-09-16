import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth_models/login_model.dart';
import '../../models/auth_models/register_model.dart';
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
  // --- NEW METHOD FOR REGISTRATION ---
  static Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String address,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
          'address': address,
        }),
      );

      final responseBody = json.decode(response.body);

      // Status code 201 is also common for successful creation
      if ((response.statusCode == 200 || response.statusCode == 201) && responseBody['status'] == 'success') {
        final registerData = RegisterData.fromJson(responseBody['data']);

        if (registerData.token.isNotEmpty) {
          await _tokenStorage.saveToken(registerData.token);
          return registerData.user;
        } else {
          throw Exception('Registration successful, but no token was provided.');
        }
      } else {
        // Handle validation errors or other API issues
        throw Exception(responseBody['message'] ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
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