import 'package:flutter/material.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const AnnouncementDetailScreen({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(announcement);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement['title'],
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              announcement['details'],
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Priority', announcement['priority']),
            _buildInfoRow('Date', announcement['createdAt']),
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

