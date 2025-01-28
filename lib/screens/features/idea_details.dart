import 'package:flutter/material.dart';

class IdeaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> idea;

  const IdeaDetailScreen({Key? key, required this.idea}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(idea);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              idea['title'],
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              'Details: ${idea['description']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Status', idea['status']),
            _buildInfoRow('Votes', idea['votes'].toString()),
            const SizedBox(height: 16),
            Text(
              'Submitted by',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(idea['submittedBy'] ?? 'Anonymous'),
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

