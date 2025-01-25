import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/auth_service.dart';
import 'package:smart_dhaka_app/widgets/dashboard_feature_card.dart';

class ServiceHolderDashboard extends StatelessWidget {
  const ServiceHolderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Service Holder Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTaskSummary(context),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                DashboardFeatureCard(
                  icon: Icons.assignment,
                  title: 'Assigned Tasks',
                  route: '/assigned-tasks',
                ),
                DashboardFeatureCard(
                  icon: Icons.track_changes,
                  title: 'Track Emergency Responses',
                  route: '/track-emergency-responses',
                ),
                DashboardFeatureCard(
                  icon: Icons.update,
                  title: 'Update Service Status',
                  route: '/update-service-status',
                ),
                DashboardFeatureCard(
                  icon: Icons.assessment,
                  title: 'Performance Metrics',
                  route: '/performance-metrics',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTaskStatistic(context, 'Pending', '5', Colors.orange),
                _buildTaskStatistic(context, 'In Progress', '3', Colors.blue),
                _buildTaskStatistic(context, 'Completed', '12', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatistic(
      BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
              ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.logout();

      // Navigate to the login screen
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }
}
