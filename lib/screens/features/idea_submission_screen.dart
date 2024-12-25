import 'package:flutter/material.dart';

class IdeaSubmissionScreen extends StatefulWidget {
  const IdeaSubmissionScreen({Key? key}) : super(key: key);

  @override
  _IdeaSubmissionScreenState createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Submission'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Idea Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your idea';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement file upload functionality
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Attachment (Optional)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitIdea,
                child: const Text('Submit Idea'),
              ),
              const SizedBox(height: 32),
              Text(
                'Recent Ideas',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              _buildIdeaList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdeaList() {
    // TODO: Replace with actual idea data
    final ideas = [
      {'id': 1, 'description': 'Install solar panels in public buildings', 'votes': 25, 'status': 'Under Review'},
      {'id': 2, 'description': 'Create more green spaces in the city', 'votes': 18, 'status': 'Approved'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ideas.length,
      itemBuilder: (context, index) {
        final idea = ideas[index];
        return Card(
          child: ListTile(
            title: Text(idea['description'] as String),
            subtitle: Text('Status: ${idea['status']}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${idea['votes']} votes'),
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    // TODO: Implement voting functionality
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitIdea() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement idea submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Idea submitted successfully')),
      );
      _descriptionController.clear();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

