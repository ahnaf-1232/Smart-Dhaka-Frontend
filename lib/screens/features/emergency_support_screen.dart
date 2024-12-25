import 'package:flutter/material.dart';

class EmergencySupportScreen extends StatelessWidget {
  const EmergencySupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Emergency Type',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showNearestServiceStation(context, 'Hospital'),
              icon: const Icon(Icons.local_hospital),
              label: const Text('Hospital'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showNearestServiceStation(context, 'Police'),
              icon: const Icon(Icons.local_police),
              label: const Text('Police'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showNearestServiceStation(context, 'Fire'),
              icon: const Icon(Icons.local_fire_department),
              label: const Text('Fire'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNearestServiceStation(BuildContext context, String serviceType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nearest $serviceType Station'),
          content: Text('The nearest $serviceType station is 2.5 km away.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement navigation to the service station
                Navigator.of(context).pop();
              },
              child: const Text('Navigate'),
            ),
          ],
        );
      },
    );
  }
}

