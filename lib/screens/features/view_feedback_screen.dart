import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/feedback_details.dart';
import 'package:smart_dhaka_app/services/feedback_service.dart';

class ViewFeedbackScreen extends StatefulWidget {
  const ViewFeedbackScreen({Key? key}) : super(key: key);

  @override
  _ViewFeedbackScreenState createState() => _ViewFeedbackScreenState();
}

class _ViewFeedbackScreenState extends State<ViewFeedbackScreen> {
  late Future<List<Map<String, dynamic>>> _feedbackFuture;
  final FeedbackService _feedbackService = FeedbackService();

  @override
  void initState() {
    super.initState();
    _feedbackFuture = _feedbackService.getAllFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Feedback'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _feedbackFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feedbacks found.'));
          } else {
            final feedbackList = snapshot.data!;
            return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(feedback['feedbackGiverName'] ?? 'Anonymous'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feedback['content']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < feedback['rating']
                                    ? Icons.star
                                    : Icons.star_border,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackDetailScreen(
                            feedback: feedback,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
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
