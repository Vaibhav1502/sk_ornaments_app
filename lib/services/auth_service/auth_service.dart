import 'dart:convert';
import 'dart:io'; // Used to check the platform (Android/iOS)
import 'package:http/http.dart' as http;

// Import all necessary auth models
import '../../models/auth_models/login_model.dart';
import '../../models/auth_models/register_model.dart';
import '../../models/auth_models/profile_model.dart';

// Import the secure storage service
import '../storage/token_storage_service.dart';

/// A service class for handling all authentication-related API calls.
/// This includes login, registration, fetching profiles, logout, and checking login status.
class AuthService {
  // Use '10.0.2.2' for Android emulators to connect to the host machine's localhost.
  // For iOS simulators and physical devices, '127.0.0.1' is fine.
  static final String _baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/v1'
      : 'http://127.0.0.1:8000/api/v1';

  // A single instance of the token storage service for all methods to use.
  static final TokenStorageService _tokenStorage = TokenStorageService();

  /// Logs in a user with the provided email and password.
  ///
  /// On success, it securely stores the authentication token and returns the [User] object.
  /// Throws an [Exception] if the login fails due to incorrect credentials or other API errors.
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

        if (loginData.token.isNotEmpty) {
          await _tokenStorage.saveToken(loginData.token);
          return loginData.user;
        } else {
          throw Exception('Login successful, but no token was provided by the server.');
        }
      } else {
        throw Exception(responseBody['message'] ?? 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new user with the provided details.
  ///
  /// On success, it securely stores the authentication token and returns the newly created [User] object.
  /// Throws an [Exception] if registration fails due to validation errors or other API issues.
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

      if ((response.statusCode == 200 || response.statusCode == 201) && responseBody['status'] == 'success') {
        final registerData = RegisterData.fromJson(responseBody['data']);

        if (registerData.token.isNotEmpty) {
          await _tokenStorage.saveToken(registerData.token);
          return registerData.user;
        } else {
          throw Exception('Registration successful, but no token was provided by the server.');
        }
      } else {
        throw Exception(responseBody['message'] ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the profile of the currently logged-in user.
  ///
  /// Requires a valid authentication token to be stored.
  /// Returns a [User] object on success.
  /// Throws an [Exception] if the user is not authenticated or if the request fails.
  static Future<User> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/user/profile');

    // 1. Retrieve the stored token before making the call.
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('Authentication error: No token found. Please log in.');
    }

    try {
      // 2. Make the GET request with the Authorization header.
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        final profileData = ProfileData.fromJson(responseBody['data']);
        return profileData.user;
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to retrieve profile.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logs out the current user by deleting their stored authentication token.
  static Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  /// Checks if a user is currently logged in by verifying the presence of a token.
  ///
  /// Returns `true` if a token exists, `false` otherwise.
  static Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getToken();
    return token != null;
  }
}