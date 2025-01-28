import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class IdeaService {
  final String baseUrl;

  IdeaService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<void> submitIdea(
      String title, String description, String token) async {
    final String url = '$baseUrl/ideas/submit'; // Adjust endpoint as needed

    try {
      final Map<String, dynamic> requestBody = {
        'description': description,
        'title': title,
        // 'imageUrl': imageUrl,
        // Add more fields if required by the backend
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in headers
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode != 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        throw Exception(responseData['error'] ?? 'Failed to submit idea');
      }
    } catch (e) {
      print('Error submitting idea: $e');
      throw Exception('Error submitting idea: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getIdeas(
      {required bool getMyIdeas, required bool getAllIdeas}) async {
    String url = '';

    if (getAllIdeas) {
      url = '$baseUrl/ideas/all-ideas';
    } else if (getMyIdeas) {
      url = '$baseUrl/ideas/my-ideas';
    }

    try {
      // Retrieve the token from secure storage
      final String? token = await getAuthToken();

      if (token == null) {
        throw Exception('User not authenticated. Please log in again.');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((idea) => {
                  '_id': idea['_id'],
                  'id': idea['id'],
                  'title': idea['title'],
                  'description': idea['description'],
                  'votes': idea['votes'],
                  'status': idea['status'],
                  'hasVoted': idea['hasVoted'],
                })
            .toList();
      } else {
        throw Exception(
            'Failed to fetch ideas. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ideas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchIdeasForAuthority() async {
    try {
      // Retrieve the authentication token
      final String? token = await getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found.');
      }

      // Make the HTTP GET request with the token in the headers
      final response = await http.get(
        Uri.parse('$baseUrl/ideas/authority-ideas'),
        headers: {
          'Authorization':
              'Bearer $token', // Include the token in the Authorization header
          'Content-Type':
              'application/json', // Optional: Specify the content type
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body and return the ideas
        final data = json.decode(response.body);

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
            'Failed to fetch ideas. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ideas: $e');
    }
  }

  Future<Map<String, dynamic>> updateIdeaStatus(
      String ideaId, String status) async {
    try {
      final String? token = await getAuthToken(); // Fetch the auth token
      final response = await http.put(
        Uri.parse('$baseUrl/ideas/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'ideaId': ideaId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating idea status: $e');
    }
  }
}
