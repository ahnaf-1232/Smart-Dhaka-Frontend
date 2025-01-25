import 'package:flutter/material.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintDetailScreen({Key? key, required this.complaint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(complaint);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint['description'],
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Status', complaint['status']),
            // _buildInfoRow('Priority', complaint['priority']),
            _buildInfoRow('Votes', complaint['votes'].toString()),
            const SizedBox(height: 16),
            Text(
              'Location',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(complaint['address']),
            const SizedBox(height: 8),
            Text('Latitude: ${complaint['lat']}'),
            Text('Longitude: ${complaint['lng']}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

