import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/emergnecy_service.dart';

class UpdateServiceStatusScreen extends StatefulWidget {
  const UpdateServiceStatusScreen({Key? key}) : super(key: key);

  @override
  _UpdateServiceStatusScreenState createState() =>
      _UpdateServiceStatusScreenState();
}

class _UpdateServiceStatusScreenState extends State<UpdateServiceStatusScreen> {
  final EmergencyService _emergencyService = EmergencyService();
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmergencyServices();
  }

  Future<void> _fetchEmergencyServices() async {
    try {
      final services = await _emergencyService.getAssignedTasks();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch services: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices =
        _services.where((service) => service['status'] != 'Closed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Service Status'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredServices.isEmpty
              ? const Center(
                  child: Text(
                    'No services to show.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                            'Emergency Support for ${service['requester']['name']}'),
                        subtitle: Text('Current Status: ${service['status']}'),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              _updateStatus(context, service['_id']),
                          child: const Text('Update'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _updateStatus(BuildContext context, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedStatus;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Update Service Status'),
              content: DropdownButton<String>(
                value: selectedStatus,
                hint: const Text('Select Status'),
                items: <String>['Pending', 'In Progress', 'Resolved']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedStatus != null) {
                      try {
                        await _emergencyService.updateServiceStatus(
                          serviceId,
                          selectedStatus!,
                        );
                        setState(() {
                          _services = _services.map((service) {
                            if (service['_id'] == serviceId) {
                              service['status'] = selectedStatus!;
                            }
                            return service;
                          }).toList();
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Status updated for service #$serviceId')),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to update status: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
