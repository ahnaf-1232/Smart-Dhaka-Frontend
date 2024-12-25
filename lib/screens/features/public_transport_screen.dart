import 'package:flutter/material.dart';

class PublicTransportScreen extends StatefulWidget {
  const PublicTransportScreen({Key? key}) : super(key: key);

  @override
  _PublicTransportScreenState createState() => _PublicTransportScreenState();
}

class _PublicTransportScreenState extends State<PublicTransportScreen> {
  String _selectedTransportType = 'Metro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Transport Information'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Metro', label: Text('Metro')),
                ButtonSegment(value: 'Bus', label: Text('Bus')),
                ButtonSegment(value: 'Train', label: Text('Train')),
              ],
              selected: {_selectedTransportType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedTransportType = newSelection.first;
                });
              },
            ),
          ),
          Expanded(
            child: _buildTransportSchedule(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportSchedule() {
    // TODO: Replace with actual transport data
    final scheduleData = [
      {'route': 'Route 1', 'departure': '10:00 AM', 'arrival': '10:30 AM'},
      {'route': 'Route 2', 'departure': '10:15 AM', 'arrival': '10:45 AM'},
      {'route': 'Route 3', 'departure': '10:30 AM', 'arrival': '11:00 AM'},
    ];

    return ListView.builder(
      itemCount: scheduleData.length,
      itemBuilder: (context, index) {
        final schedule = scheduleData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(schedule['route'] as String),
            subtitle: Text('Departure: ${schedule['departure']} | Arrival: ${schedule['arrival']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement route details view
            },
          ),
        );
      },
    );
  }
}

