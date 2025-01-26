import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_dhaka_app/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl;
  AuthService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(
      String email, String password, String userType) async {
    final String url = '${dotenv.env['API_URL']!}/auth/login';

    try {
      // Create the request body
      final Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
        "userType": userType,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Process the response
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Create and return the User object
        return {
          'role': responseData['role'],
          'token': responseData['token'],
        };
      } else {
        // Handle non-200 status codes
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle network or parsing errors
      print('An error occurred during login: $e');
      return null;
    }
  }

  Future<void> register(
      String name,
      String email,
      String password,
      String nid,
      String thana,
      String houseNo) async {
    final String url = '${dotenv.env['API_URL']!}/auth/register';

    try {
      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "password": password,
        "nid": nid,
        "thana": thana,
        "houseNo": houseNo,
        "role": "Resident"
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful: ${response.body}');
      } else {
        print('Registration failed: ${response.body}');
        throw Exception(
            'Failed to register. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('Registration failed due to an error');
    }
  }

  Future<void> createAdminUser(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/create-admin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Admin user: ${response.body}');
    }
  }

  Future<void> createServiceHolderUser(
      String name, String email, String password, String serviceType, String thana, double lat, double lng) async {
    final url = Uri.parse('$baseUrl/auth/create-service-holder');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'serviceType': serviceType,
        'thana': thana,
        'lat': lat,
        'lng': lng,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Service Holder user: ${response.body}');
    }
  }

  Future<void> createAuthorityUser(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/create-govt-authority');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Authority user: ${response.body}');
    }
  }

  Future<String?> validateToken() async {
    final token = await _secureStorage.read(key: 'authToken');

    if (token == null) {
      return null; // No token available
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/validate-token'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['role'];
    } else {
      await logout(); // Token invalid, log out the user
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Clear the token from secure storage
      await _secureStorage.delete(key: 'authToken');
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Logout failed');
    }
  }
}
