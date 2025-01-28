import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnnouncementService {
  final String baseUrl;
  AnnouncementService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    final String url = '$baseUrl/announcements/all-announcements';
    final String? token = await _secureStorage.read(key: 'authToken');

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch announcements: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching announcements: $error');
    }
  }

  Future<void> submitAnnouncement(String title, String content, String thana, String priority) async {
    final url = Uri.parse('$baseUrl/announcements/add');
    final String? token = await _secureStorage.read(key: 'authToken');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Replace with actual token handling
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'thana': thana,
          'priority': priority,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit announcement: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while submitting announcement: $e');
    }
  }

  Future<void> updateAnnouncement(String id, String title, String content, String priority) async {
    // TODO: Implement API call to update announcement
    await Future.delayed(const Duration(seconds: 1)); // Simulating API call
    print('Announcement updated: $id, $title, $content, $priority');
  }

  Future<void> deleteAnnouncement(String id) async {
    // TODO: Implement API call to delete announcement
    await Future.delayed(const Duration(seconds: 1)); // Simulating API call
    print('Announcement deleted: $id');
  }
}
