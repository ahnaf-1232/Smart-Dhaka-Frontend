import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  final String baseUrl = dotenv.env['API_URL']!; // Fetch API URL from .env
  final _secureStorage = const FlutterSecureStorage();

  Future<void> submitFeedback(String title, String content, int rating) async {
    print('Submitting feedback: $title, $content, $rating');
    final url = Uri.parse('$baseUrl/feedbacks/create');
    final token = await _secureStorage.read(key: 'authToken'); // Get token from secure storage

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'rating': rating,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit feedback: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserFeedbacks() async {
    final url = Uri.parse('$baseUrl/feedbacks/my-feedbacks');
    final token = await _secureStorage.read(key: 'authToken'); // Get token from secure storage

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch feedbacks: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFeedbacks() async {
    final url = Uri.parse('$baseUrl/feedbacks/all');
    final token = await _secureStorage.read(key: 'authToken');

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch feedbacks: ${response.body}');
    }
  }
}
