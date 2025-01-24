import 'package:flutter/material.dart';

class UtilityManagementScreen extends StatelessWidget {
  const UtilityManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utility Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUtilityCard(
            context,
            'Electricity',
            Icons.electric_bolt,
            'Last Bill: ৳1,200',
            'Due Date: 15th May 2023',
          ),
          const SizedBox(height: 16),
          _buildUtilityCard(
            context,
            'Wi-Fi',
            Icons.wifi,
            'Last Bill: ৳800',
            'Due Date: 20th May 2023',
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityCard(BuildContext context, String title, IconData icon, String lastBill, String dueDate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Text(lastBill),
            Text(dueDate),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement pay now functionality
                  },
                  child: const Text('Pay Now'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement set schedule functionality
                  },
                  child: const Text('Set Schedule'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

