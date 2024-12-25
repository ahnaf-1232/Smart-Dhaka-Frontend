import 'package:flutter/material.dart';

class ComplaintSystemScreen extends StatefulWidget {
  const ComplaintSystemScreen({Key? key}) : super(key: key);

  @override
  _ComplaintSystemScreenState createState() => _ComplaintSystemScreenState();
}

class _ComplaintSystemScreenState extends State<ComplaintSystemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint System'),
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
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement image upload functionality
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Image (Optional)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitComplaint,
                child: const Text('Submit Complaint'),
              ),
              const SizedBox(height: 32),
              Text(
                'Recent Complaints',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              _buildComplaintList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintList() {
    // TODO: Replace with actual complaint data
    final complaints = [
      {'id': 1, 'description': 'Pothole on Main Street', 'votes': 15, 'status': 'In Progress'},
      {'id': 2, 'description': 'Broken streetlight near City Park', 'votes': 8, 'status': 'Pending'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Card(
          child: ListTile(
            title: Text(complaint['description'] as String),
            subtitle: Text('Status: ${complaint['status']}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${complaint['votes']} votes'),
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

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement complaint submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
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

