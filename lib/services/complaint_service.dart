import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ComplaintService {
  final String baseUrl;

  ComplaintService() : baseUrl = dotenv.env['API_URL']!;

  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<void> submitComplaint(String address, double lat, double lng,
      String description, String token) async {
    final String url =
        '$baseUrl/complaints/submit'; // Adjust endpoint as needed

    try {
      final Map<String, dynamic> requestBody = {
        'description': description,
        'address': address,
        'lat': lat,
        'lng': lng,
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
        throw Exception(responseData['error'] ?? 'Failed to submit complaint');
      }
    } catch (e) {
      print('Error submitting complaint: $e');
      throw Exception('Error submitting complaint: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComplaints(
      {required bool getMyComplaints, required bool getAllComplaints}) async {
    String url = '';

    if (getAllComplaints) {
      url = '$baseUrl/complaints/all-complaints';
    } else if (getMyComplaints) {
      url = '$baseUrl/complaints/my-complaints';
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
            .map((complaint) => {
                  '_id': complaint['_id'],
                  'id': complaint['id'],
                  'description': complaint['description'],
                  'votes': complaint['votes'],
                  'status': complaint['status'],
                  'hasVoted': complaint['hasVoted'],
                  'address': complaint['address'],
                  'lat': complaint['lat'],
                  'lng': complaint['lng'],
                })
            .toList();
      } else {
        throw Exception(
            'Failed to fetch complaints. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching complaints: $e');
    }
  }
}
