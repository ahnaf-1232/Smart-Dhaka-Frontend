import 'package:flutter/material.dart';

class DraftAnnouncementsScreen extends StatefulWidget {
  const DraftAnnouncementsScreen({Key? key}) : super(key: key);

  @override
  _DraftAnnouncementsScreenState createState() => _DraftAnnouncementsScreenState();
}

class _DraftAnnouncementsScreenState extends State<DraftAnnouncementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft Announcement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Announcement Title',
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
                  labelText: 'Announcement Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the announcement content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitAnnouncement,
                child: const Text('Submit Announcement'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAnnouncement() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement announcement submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement submitted successfully')),
      );
      // Clear form fields after submission
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedPriority = 'Medium';
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

