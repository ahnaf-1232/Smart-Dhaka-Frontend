import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/auth_service.dart';
import 'package:smart_dhaka_app/widgets/dashboard_feature_card.dart';

class GovernmentAuthorityDashboard extends StatelessWidget {
  const GovernmentAuthorityDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Government Authority'),
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
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                DashboardFeatureCard(
                  icon: Icons.report_problem,
                  title: 'Manage Complaints',
                  route: '/manage-complaints',
                ),
                DashboardFeatureCard(
                  icon: Icons.announcement,
                  title: 'Draft Announcements',
                  route: '/draft-announcements',
                ),
                DashboardFeatureCard(
                  icon: Icons.analytics,
                  title: 'City Analytics',
                  route: '/city-analytics',
                ),
                DashboardFeatureCard(
                  icon: Icons.feedback,
                  title: 'View Feedback',
                  route: '/view-feedback',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context,
            'Pending Complaints',
            '23',
            Icons.report_problem,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            context,
            'New Feedback',
            '15',
            Icons.feedback,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color.withOpacity(0.8)),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
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
