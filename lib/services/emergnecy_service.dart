import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmergencyService {
  final String baseUrl = dotenv.env['API_URL']!;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> findNearestService(
      String category, double lat, double lng) async {
    final String url = '$baseUrl/emergencyServices/closest/$category';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'lat': lat, 'lng': lng}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
            error['error'] ?? "Failed to fetch the nearest service.");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while fetching the nearest service: $e");
    }
  }

  Future<void> createEmergencyRequest(
      String serviceHolderId, double lat, double lng) async {
    final String url = '$baseUrl/emergencyServices/create/$serviceHolderId';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'lat': lat, 'lng': lng}),
      );

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(
            error['error'] ?? "Failed to create emergency request.");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while creating the emergency request: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAssignedTasks() async {
    final String url = '$baseUrl/emergencyServices/services';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? "Failed to fetch assigned tasks.");
      }
    } catch (e) {
      throw Exception("An error occurred while fetching tasks: $e");
    }
  }

  Future<void> updateServiceStatus(String serviceId, String status) async {
    final String url = '$baseUrl/emergencyServices/update-status/$serviceId';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? "Failed to update service status.");
      }
    } catch (e) {
      throw Exception("An error occurred while updating status: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getRequestedServices() async {
    final String url = '$baseUrl/emergencyServices/requested-user-service';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? "Failed to fetch assigned tasks.");
      }
    } catch (e) {
      throw Exception("An error occurred while fetching tasks: $e");
    }
  }

  Future<void> closeEmergencyRequest(String requestId) async {
    final String url = '$baseUrl/emergencyServices/services/$requestId/close';

    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'authToken');
    if (token == null) {
      throw Exception("User not authenticated. Please log in again.");
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(
            error['message'] ?? "Failed to close emergency request.");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while closing the emergency request: $e");
    }
  }
}
