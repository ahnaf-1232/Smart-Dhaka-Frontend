import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _selectedPriority = 'All';
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          IconButton(
            icon: Icon(_notificationsEnabled ? Icons.notifications_active : Icons.notifications_off),
            onPressed: _toggleNotifications,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'All', label: Text('All')),
                ButtonSegment(value: 'High', label: Text('High')),
                ButtonSegment(value: 'Medium', label: Text('Medium')),
                ButtonSegment(value: 'Low', label: Text('Low')),
              ],
              selected: {_selectedPriority},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedPriority = newSelection.first;
                });
              },
            ),
          ),
          Expanded(
            child: _buildAnnouncementsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    // TODO: Replace with actual announcement data
    final announcements = [
      {'title': 'City-wide power maintenance', 'priority': 'High', 'date': '2023-05-10'},
      {'title': 'New bus route added', 'priority': 'Medium', 'date': '2023-05-09'},
      {'title': 'Community cleanup event', 'priority': 'Low', 'date': '2023-05-08'},
    ];

    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        if (_selectedPriority == 'All' || announcement['priority'] == _selectedPriority) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(announcement['title'] as String),
              subtitle: Text('Priority: ${announcement['priority']} | Date: ${announcement['date']}'),
              leading: _getPriorityIcon(announcement['priority'] as String),
              onTap: () {
                // TODO: Implement announcement details view
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Icon _getPriorityIcon(String priority) {
    switch (priority) {
      case 'High':
        return const Icon(Icons.priority_high, color: Colors.red);
      case 'Medium':
        return const Icon(Icons.priority_high, color: Colors.orange);
      case 'Low':
        return const Icon(Icons.info, color: Colors.blue);
      default:
        return const Icon(Icons.info);
    }
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
    // TODO: Implement push notification toggle logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled'),
      ),
    );
  }
}

