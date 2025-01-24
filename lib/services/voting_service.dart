import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class VoteService {
  final String baseUrl;

  VoteService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<void> vote(String entityType, String entityId) async {
    final String url = '$baseUrl/voting/vote';
    final String? token = await getAuthToken();

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'entityType': entityType,
          'entityId': entityId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to vote: ${response.body}');
      }

      // Optionally, handle response data
      final responseData = json.decode(response.body);
      print('Vote successful. Updated vote count: ${responseData['voteCount']}');
    } catch (error) {
      throw Exception('Error while voting: $error');
    }
  }

  Future<void> removeVote(String entityType, String entityId) async {
    final String url = '$baseUrl/voting/vote';
    final String? token = await getAuthToken();

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'entityType': entityType,
          'entityId': entityId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to vote: ${response.body}');
      }

      // Optionally, handle response data
      final responseData = json.decode(response.body);
      print('Vote successful. Updated vote count: ${responseData['voteCount']}');
    } catch (error) {
      throw Exception('Error while voting: $error');
    }
  }
}