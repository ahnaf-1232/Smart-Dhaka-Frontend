import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/feedback_details.dart';
import 'package:smart_dhaka_app/services/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FeedbackService _feedbackService = FeedbackService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submit Feedback'),
            Tab(text: 'My Feedbacks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SubmitFeedbackTab(feedbackService: _feedbackService),
          MyFeedbacksTab(feedbackService: _feedbackService),
        ],
      ),
    );
  }
}

class SubmitFeedbackTab extends StatefulWidget {
  final FeedbackService feedbackService;

  const SubmitFeedbackTab({Key? key, required this.feedbackService}) : super(key: key);

  @override
  _SubmitFeedbackTabState createState() => _SubmitFeedbackTabState();
}

class _SubmitFeedbackTabState extends State<SubmitFeedbackTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Feedback Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Feedback Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your feedback';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Rating: $_rating', style: Theme.of(context).textTheme.subtitle1),
            Slider(
              value: _rating.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (double value) {
                setState(() {
                  _rating = value.round();
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.feedbackService.submitFeedback(
          _titleController.text,
          _contentController.text,
          _rating,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully')),
        );
        _titleController.clear();
        _contentController.clear();
        setState(() {
          _rating = 3;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      }
    }
  }
}

class MyFeedbacksTab extends StatelessWidget {
  final FeedbackService feedbackService;

  const MyFeedbacksTab({Key? key, required this.feedbackService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: feedbackService.getUserFeedbacks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No feedbacks found.'));
        } else {
          final feedbacks = snapshot.data!;
          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(feedback['title']),
                  subtitle: Text(feedback['content']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Rating: ${feedback['rating']}'),
                      const Icon(Icons.star, color: Colors.amber),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackDetailScreen(feedback: feedback),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

