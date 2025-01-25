import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/auth_service.dart';
import 'package:smart_dhaka_app/widgets/dashboard_feature_card.dart';

class ResidentDashboard extends StatelessWidget {
  const ResidentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Resident Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 1.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          DashboardFeatureCard(
            icon: Icons.map,
            title: 'Shortest Path',
            route: '/shortest-path',
          ),
          DashboardFeatureCard(
            icon: Icons.emergency,
            title: 'Emergency Support',
            route: '/emergency-support',
          ),
          // DashboardFeatureCard(
          //   icon: Icons.electric_bolt,
          //   title: 'Utility Management',
          //   route: '/utility-management',
          // ),
          DashboardFeatureCard(
            icon: Icons.report_problem,
            title: 'Complaint System',
            route: '/complaint-system',
          ),
          DashboardFeatureCard(
            icon: Icons.lightbulb,
            title: 'Idea Submission',
            route: '/idea-submission',
          ),
          DashboardFeatureCard(
            icon: Icons.directions_bus,
            title: 'Public Transport',
            route: '/public-transport',
          ),
          DashboardFeatureCard(
            icon: Icons.announcement,
            title: 'Announcements',
            route: '/announcements',
          ),
          DashboardFeatureCard(
            icon: Icons.emoji_events,
            title: 'Engagement & Rewards',
            route: '/engagement-rewards',
          ),
          DashboardFeatureCard(
            icon: Icons.feedback,
            title: 'Feedback',
            route: '/feedback',
          ),
        ],
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
