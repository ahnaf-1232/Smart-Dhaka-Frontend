import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  UserService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<List<Map<String, dynamic>>> fetchUsers(String userType) async {
    String endpoint;

    switch (userType) {
      case 'Admin':
        endpoint = '/users/admins';
        break;
      case 'Service Holder':
        endpoint = '/users/service-holders';
        break;
      case 'Authority':
        endpoint = '/users/govt-authorities';
        break;
      case 'Resident':
        endpoint = '/users/residents';
        break;
      default:
        throw Exception('Invalid user type');
    }

    final String? token = await getAuthToken();

    if (token == null) {
      throw Exception('User not authenticated. Please log in again.');
    }

    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load $userType users: ${response.body}');
    }
  }
}
