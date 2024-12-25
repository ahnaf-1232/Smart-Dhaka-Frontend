import 'package:flutter/material.dart';

class EngagementRewardsScreen extends StatelessWidget {
  const EngagementRewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engagement & Rewards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPointsSummary(context),
            const SizedBox(height: 24),
            _buildLeaderboard(context),
            const SizedBox(height: 24),
            _buildRewardsEarned(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Points',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              '1,250',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Keep engaging to earn more points!'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    final leaderboardData = [
      {'name': 'John Doe', 'points': 1500},
      {'name': 'Jane Smith', 'points': 1350},
      {'name': 'You', 'points': 1250},
      {'name': 'Mike Johnson', 'points': 1100},
      {'name': 'Sarah Williams', 'points': 950},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final entry = leaderboardData[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(entry['name'] as String),
                  trailing: Text('${entry['points']} pts'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsEarned(BuildContext context) {
    final rewardsData = [
      {'name': 'Free Bus Ride', 'points': 500},
      {'name': '10% Discount on Utility Bill', 'points': 1000},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rewards Earned',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewardsData.length,
              itemBuilder: (context, index) {
                final reward = rewardsData[index];
                return ListTile(
                  title: Text(reward['name'] as String),
                  trailing: Text('${reward['points']} pts'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

