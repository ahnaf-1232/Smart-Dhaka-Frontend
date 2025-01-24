import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/widgets/dashboard_feature_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSystemPerformance(context),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                DashboardFeatureCard(
                  icon: Icons.person_add,
                  title: 'Create User',
                  route: '/user-creation',
                ),
                DashboardFeatureCard(
                  icon: Icons.people,
                  title: 'User Management',
                  route: '/user-management',
                ),
                DashboardFeatureCard(
                  icon: Icons.analytics,
                  title: 'System Analytics',
                  route: '/system-analytics',
                ),
                DashboardFeatureCard(
                  icon: Icons.settings,
                  title: 'System Settings',
                  route: '/system-settings',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemPerformance(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Performance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceMetric(context, 'CPU Usage', '45%', Colors.green),
                _buildPerformanceMetric(context, 'Memory', '60%', Colors.orange),
                _buildPerformanceMetric(context, 'Disk Space', '75%', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(BuildContext context, String label, String value, Color color) {
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
}

