import 'package:flutter/material.dart';

class UpdateServiceStatusScreen extends StatefulWidget {
  const UpdateServiceStatusScreen({Key? key}) : super(key: key);

  @override
  _UpdateServiceStatusScreenState createState() => _UpdateServiceStatusScreenState();
}

class _UpdateServiceStatusScreenState extends State<UpdateServiceStatusScreen> {
  final List<Map<String, dynamic>> services = [
    {'id': 1, 'name': 'Water Supply', 'status': 'Operational'},
    {'id': 2, 'name': 'Electricity', 'status': 'Maintenance'},
    {'id': 3, 'name': 'Waste Collection', 'status': 'Operational'},
    {'id': 4, 'name': 'Public Transport', 'status': 'Delayed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Service Status'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(service['name']),
              subtitle: Text('Current Status: ${service['status']}'),
              trailing: ElevatedButton(
                onPressed: () => _updateStatus(context, service['id']),
                child: const Text('Update'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateStatus(BuildContext context, int serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Service Status'),
          content: DropdownButton<String>(
            value: services.firstWhere((s) => s['id'] == serviceId)['status'],
            items: <String>['Operational', 'Maintenance', 'Delayed', 'Suspended']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  services.firstWhere((s) => s['id'] == serviceId)['status'] = newValue;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Status updated for service #$serviceId')),
                );
              }
            },
          ),
        );
      },
    );
  }
}

