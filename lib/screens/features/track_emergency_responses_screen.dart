import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_dhaka_app/services/emergnecy_service.dart';

class TrackEmergencyResponsesScreen extends StatefulWidget {
  const TrackEmergencyResponsesScreen({Key? key}) : super(key: key);

  @override
  _TrackEmergencyResponsesScreenState createState() =>
      _TrackEmergencyResponsesScreenState();
}

class _TrackEmergencyResponsesScreenState
    extends State<TrackEmergencyResponsesScreen> {
  final EmergencyService _emergencyService = EmergencyService();
  List<Map<String, dynamic>> _emergencies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmergencyResponses();
  }

  Future<void> _fetchEmergencyResponses() async {
    try {
      final emergencies = await _emergencyService.getAssignedTasks();

      setState(() {
        _emergencies = emergencies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch emergency responses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Emergency Responses'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _emergencies.length,
              itemBuilder: (context, index) {
                final emergency = _emergencies[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: _getEmergencyIcon(emergency['role']),
                    title: Text(
                        'Emergency Service for: ${emergency['requester']['name']}'),
                    subtitle: Text(
                        'Latitude: ${emergency['requesterLocation']['lat']} \nLongitude: ${emergency['requesterLocation']['lng']} \nTime: ${emergency['time']}'),
                    trailing: Chip(
                      label: Text(emergency['status']),
                      backgroundColor: _getStatusColor(emergency['status']),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Icon _getEmergencyIcon(String role) {
    switch (role) {
      case 'Hospital':
        return const Icon(Icons.medical_services, color: Colors.green);
      case 'Police':
        return const Icon(Icons.local_police, color: Colors.blue);
      case 'Fire Service':
        return const Icon(Icons.local_fire_department, color: Colors.red);
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
}
