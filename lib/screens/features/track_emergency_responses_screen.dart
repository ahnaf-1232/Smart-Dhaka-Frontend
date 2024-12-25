import 'package:flutter/material.dart';

class TrackEmergencyResponsesScreen extends StatelessWidget {
  const TrackEmergencyResponsesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> emergencies = [
      {'id': 1, 'type': 'Fire', 'location': '123 Main St', 'status': 'In Progress', 'time': '10:30 AM'},
      {'id': 2, 'type': 'Medical', 'location': '456 Elm St', 'status': 'Resolved', 'time': '11:45 AM'},
      {'id': 3, 'type': 'Police', 'location': '789 Oak St', 'status': 'Pending', 'time': '12:15 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Emergency Responses'),
      ),
      body: ListView.builder(
        itemCount: emergencies.length,
        itemBuilder: (context, index) {
          final emergency = emergencies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: _getEmergencyIcon(emergency['type']),
              title: Text('${emergency['type']} Emergency'),
              subtitle: Text('Location: ${emergency['location']}\nTime: ${emergency['time']}'),
              trailing: Chip(
                label: Text(emergency['status']),
                backgroundColor: _getStatusColor(emergency['status']),
              ),
              onTap: () => _viewEmergencyDetails(context, emergency['id']),
            ),
          );
        },
      ),
    );
  }

  Icon _getEmergencyIcon(String type) {
    switch (type) {
      case 'Fire':
        return const Icon(Icons.local_fire_department, color: Colors.red);
      case 'Medical':
        return const Icon(Icons.medical_services, color: Colors.green);
      case 'Police':
        return const Icon(Icons.local_police, color: Colors.blue);
      default:
        return const Icon(Icons.warning, color: Colors.orange);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'Pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewEmergencyDetails(BuildContext context, int emergencyId) {
    // TODO: Implement emergency details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for emergency #$emergencyId')),
    );
  }
}

