import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/announcement_details.dart';
import 'package:smart_dhaka_app/services/announcement_service.dart';
import 'package:smart_dhaka_app/widgets/thana_selector.dart';

class DraftAnnouncementsScreen extends StatefulWidget {
  const DraftAnnouncementsScreen({Key? key}) : super(key: key);

  @override
  _DraftAnnouncementsScreenState createState() => _DraftAnnouncementsScreenState();
}

class _DraftAnnouncementsScreenState extends State<DraftAnnouncementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AnnouncementService _announcementService = AnnouncementService();

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
        title: const Text('Manage Announcements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submit Announcement'),
            Tab(text: 'My Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SubmitAnnouncementTab(announcementService: _announcementService),
          MyAnnouncementsTab(announcementService: _announcementService),
        ],
      ),
    );
  }
}

class SubmitAnnouncementTab extends StatefulWidget {
  final AnnouncementService announcementService;

  const SubmitAnnouncementTab({Key? key, required this.announcementService}) : super(key: key);

  @override
  _SubmitAnnouncementTabState createState() => _SubmitAnnouncementTabState();
}

class _SubmitAnnouncementTabState extends State<SubmitAnnouncementTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedThana;
  String _selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            ThanaSelector(
            selectedThana: _selectedThana,
            onChanged: (value) {
              setState(() {
                _selectedThana = value;
              });
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
    );
  }

  void _submitAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.announcementService.submitAnnouncement(
          _titleController.text,
          _contentController.text,
          _selectedThana!,
          _selectedPriority,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement submitted successfully')),
        );

        // Clear form fields after submission
        _titleController.clear();
        _contentController.clear();
        setState(() {
          _selectedPriority = 'Medium';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit announcement: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class MyAnnouncementsTab extends StatefulWidget {
  final AnnouncementService announcementService;

  const MyAnnouncementsTab({Key? key, required this.announcementService}) : super(key: key);

  @override
  _MyAnnouncementsTabState createState() => _MyAnnouncementsTabState();
}

class _MyAnnouncementsTabState extends State<MyAnnouncementsTab> {
  late Future<List<Map<String, dynamic>>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  void _fetchAnnouncements() {
    setState(() {
      _announcementsFuture = widget.announcementService.getAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _announcementsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No announcements found.'));
        } else {
          final announcements = snapshot.data!;
          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(announcement['title']),
                  subtitle: Text('Priority: ${announcement['priority']} | Date: ${announcement['createdAt']}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'edit') {
                        _editAnnouncement(context, announcement);
                      } else if (result == 'delete') {
                        _deleteAnnouncement(context, announcement['id']);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementDetailScreen(
                      announcement: announcement,
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
    );
  }

  void _editAnnouncement(BuildContext context, Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController(text: announcement['title']);
        final TextEditingController contentController = TextEditingController(text: announcement['content']);
        String priority = announcement['priority'];

        return AlertDialog(
          title: const Text('Edit Announcement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      priority = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  await widget.announcementService.updateAnnouncement(
                    announcement['id'],
                    titleController.text,
                    contentController.text,
                    priority,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcement updated successfully')),
                  );
                  Navigator.of(context).pop();
                  _fetchAnnouncements();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating announcement: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAnnouncement(BuildContext context, String announcementId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this announcement?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await widget.announcementService.deleteAnnouncement(announcementId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcement deleted successfully')),
                  );
                  Navigator.of(context).pop();
                  _fetchAnnouncements();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting announcement: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

