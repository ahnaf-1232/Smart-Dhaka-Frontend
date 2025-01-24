import 'package:flutter/material.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReportCard(
              context,
              'Resident Activity',
              [
                'Resolved Complaints: 5',
                'Utility Payments: ৳3,500',
                'Rewards Earned: 250 points',
              ],
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context,
              'Service Holder Performance',
              [
                'Services Delivered: 28',
                'Average Response Time: 35 minutes',
                'Customer Satisfaction: 4.7/5',
              ],
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context,
              'Government Authority Actions',
              [
                'Complaints Managed: 45',
                'Announcements Made: 12',
                'New Initiatives Launched: 3',
              ],
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context,
              'Admin Overview',
              [
                'New Users: 150',
                'System Uptime: 99.9%',
                'Data Storage Used: 75%',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item),
                )),
          ],
        ),
      ),
    );
  }
}

