import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_dhaka_app/services/emergnecy_service.dart';

class AssignedTasksScreen extends StatefulWidget {
  const AssignedTasksScreen({Key? key}) : super(key: key);

  @override
  _AssignedTasksScreenState createState() => _AssignedTasksScreenState();
}

class _AssignedTasksScreenState extends State<AssignedTasksScreen> {
  final EmergencyService _emergencyService = EmergencyService();
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssignedTasks();
  }

  Future<void> _fetchAssignedTasks() async {
    try {
      // Fetch assigned tasks from the API
      final tasks = await _emergencyService.getAssignedTasks();

      // Filter out tasks with the "Closed" status
      final filteredTasks = tasks.where((task) => task['status'] != 'Closed').toList();

      // Decode location names
      final updatedTasks = await Future.wait(filteredTasks.map((task) async {
        final locationName = await _getLocationName(
          task['requesterLocation']['lat'],
          task['requesterLocation']['lng'],
        );
        return {
          ...task,
          'locationName': locationName,
        };
      }));

      setState(() {
        _tasks = updatedTasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tasks: $e')),
      );
    }
  }

  Future<String> _getLocationName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
      return 'Unknown location';
    } catch (e) {
      return 'Unknown location';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Tasks'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks to show.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          "Send Emergency Support Immediately to ${task['requester']['name']}\n",
                        ),
                        subtitle: Text(
                          'Requester name: ${task['requester']['name']} \n'
                          'Latitude: ${task['requesterLocation']['lat']} | Longitude: ${task['requesterLocation']['lng']}\n'
                          'Address: ${task['locationName']}\n'
                          'Phone: ${task['requester']['phone']}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
