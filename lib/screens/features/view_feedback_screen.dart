import 'package:flutter/material.dart';

class ViewFeedbackScreen extends StatefulWidget {
  const ViewFeedbackScreen({Key? key}) : super(key: key);

  @override
  _ViewFeedbackScreenState createState() => _ViewFeedbackScreenState();
}

class _ViewFeedbackScreenState extends State<ViewFeedbackScreen> {
  final List<Map<String, dynamic>> _feedbackList = [
    {'id': 1, 'user': 'John Doe', 'content': 'Great initiative! The app is very helpful.', 'rating': 5},
    {'id': 2, 'user': 'Jane Smith', 'content': 'The complaint system needs improvement.', 'rating': 3},
    {'id': 3, 'user': 'Mike Johnson', 'content': 'Love the real-time updates on public transport.', 'rating': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Feedback'),
      ),
      body: ListView.builder(
        itemCount: _feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = _feedbackList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(feedback['user']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feedback['content']),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < feedback['rating'] ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () => _replyToFeedback(feedback['id']),
              ),
            ),
          );
        },
      ),
    );
  }

  void _replyToFeedback(int feedbackId) {
    // TODO: Implement reply functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Replying to feedback #$feedbackId')),
    );
  }
}

