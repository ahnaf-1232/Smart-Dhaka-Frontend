import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_dhaka_app/config/theme.dart';
import 'package:smart_dhaka_app/screens/auth/login_screen.dart';
import 'package:smart_dhaka_app/screens/auth/registration_screen.dart';
import 'package:smart_dhaka_app/screens/dashboards/resident_dashboard.dart';
import 'package:smart_dhaka_app/screens/dashboards/service_holder_dashboard.dart';
import 'package:smart_dhaka_app/screens/dashboards/government_authority_dashboard.dart';
import 'package:smart_dhaka_app/screens/dashboards/admin_dashboard.dart';
import 'package:smart_dhaka_app/screens/features/feedback_screen.dart';
import 'package:smart_dhaka_app/screens/features/shortest_path_screen.dart';
import 'package:smart_dhaka_app/screens/features/emergency_support_screen.dart';
import 'package:smart_dhaka_app/screens/features/user_creation_screen.dart';
import 'package:smart_dhaka_app/screens/features/utility_management_screen.dart';
import 'package:smart_dhaka_app/screens/features/complaint_system_screen.dart';
import 'package:smart_dhaka_app/screens/features/idea_submission_screen.dart';
import 'package:smart_dhaka_app/screens/features/engagement_rewards_screen.dart';
import 'package:smart_dhaka_app/screens/features/public_transport_screen.dart';
import 'package:smart_dhaka_app/screens/features/announcements_screen.dart';
import 'package:smart_dhaka_app/screens/features/community_map_update_screen.dart';
import 'package:smart_dhaka_app/screens/features/monthly_report_screen.dart';
import 'package:smart_dhaka_app/screens/features/manage_complaints_screen.dart';
import 'package:smart_dhaka_app/screens/features/draft_announcements_screen.dart';
import 'package:smart_dhaka_app/screens/features/city_analytics_screen.dart';
import 'package:smart_dhaka_app/screens/features/view_feedback_screen.dart';
import 'package:smart_dhaka_app/screens/features/assigned_tasks_screen.dart';
import 'package:smart_dhaka_app/screens/features/track_emergency_responses_screen.dart';
import 'package:smart_dhaka_app/screens/features/update_service_status_screen.dart';
import 'package:smart_dhaka_app/screens/features/performance_metrics_screen.dart';
import 'package:smart_dhaka_app/screens/features/user_management_screen.dart';
import 'package:smart_dhaka_app/screens/features/role_assignment_screen.dart';
import 'package:smart_dhaka_app/screens/features/system_analytics_screen.dart';
import 'package:smart_dhaka_app/screens/features/system_settings_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/frontend.env");
  runApp(const SmartDhakaApp());
}

class SmartDhakaApp extends StatelessWidget {
  const SmartDhakaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Dhaka',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/resident-dashboard': (context) => const ResidentDashboard(),
        '/shortest-path': (context) => const ShortestPathScreen(),
        '/emergency-support': (context) => const EmergencySupportScreen(),
        '/utility-management': (context) => const UtilityManagementScreen(),
        '/complaint-system': (context) => const ComplaintSystemScreen(),
        '/idea-submission': (context) => const IdeaSubmissionScreen(),
        '/engagement-rewards': (context) => const EngagementRewardsScreen(),
        '/public-transport': (context) => const PublicTransportScreen(),
        '/announcements': (context) => const AnnouncementsScreen(),
        '/service-holder-dashboard': (context) => const ServiceHolderDashboard(),
        '/government-authority-dashboard': (context) => const GovernmentAuthorityDashboard(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/community-map-update': (context) => const CommunityMapUpdateScreen(),
        '/monthly-report': (context) => const MonthlyReportScreen(),
        '/manage-complaints': (context) => const ManageComplaintsScreen(),
        '/draft-announcements': (context) => const DraftAnnouncementsScreen(),
        '/city-analytics': (context) => const CityAnalyticsScreen(),
        '/view-feedback': (context) => const ViewFeedbackScreen(),
        '/assigned-tasks': (context) => const AssignedTasksScreen(),
        '/track-emergency-responses': (context) => const TrackEmergencyResponsesScreen(),
        '/update-service-status': (context) => const UpdateServiceStatusScreen(),
        '/performance-metrics': (context) => const PerformanceMetricsScreen(),
        '/user-management': (context) => const UserManagementScreen(),
        '/role-assignment': (context) => const RoleAssignmentScreen(),
        '/system-analytics': (context) => const SystemAnalyticsScreen(),
        '/system-settings': (context) => const SystemSettingsScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/user-creation': (context) => const UserCreationScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },
    );
  }
}

