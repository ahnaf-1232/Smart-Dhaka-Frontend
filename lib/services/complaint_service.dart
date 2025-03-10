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
      String description, String thana, String token, String title) async {
    final String url =
        '$baseUrl/complaints/submit'; // Adjust endpoint as needed

    try {
      final Map<String, dynamic> requestBody = {
        'description': description,
        'address': address,
        'lat': lat,
        'lng': lng,
        'thana': thana,
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
                  'title': complaint['title'],
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

  Future<List<Map<String, dynamic>>> fetchComplaintsForAuthority() async {
    try {
      // Retrieve the authentication token
      final String? token = await getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found.');
      }

      // Make the HTTP GET request with the token in the headers
      final response = await http.get(
        Uri.parse('$baseUrl/complaints/authority-complaints'),
        headers: {
          'Authorization':
              'Bearer $token', // Include the token in the Authorization header
          'Content-Type':
              'application/json', // Optional: Specify the content type
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body and return the complaints
        final data = json.decode(response.body);

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
            'Failed to fetch complaints. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching complaints: $e');
    }
  }

  Future<Map<String, dynamic>> updateComplaintStatus(
      String complaintId, String status) async {
        print('complaintId: $complaintId, status: $status');
    try {
      final String? token = await getAuthToken(); // Fetch the auth token
      final response = await http.put(
        Uri.parse('$baseUrl/complaints/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'complaintId': complaintId,
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
      throw Exception('Error updating complaint status: $e');
    }
  }
}
