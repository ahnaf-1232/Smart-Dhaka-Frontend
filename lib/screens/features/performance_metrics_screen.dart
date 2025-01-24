import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceMetricsScreen extends StatelessWidget {
  const PerformanceMetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Metrics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(context),
            const SizedBox(height: 24),
            _buildTaskCompletionChart(context),
            const SizedBox(height: 24),
            _buildResponseTimeChart(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(context, 'Tasks Completed', '45'),
                _buildSummaryItem(context, 'Avg. Response Time', '28 min'),
                _buildSummaryItem(context, 'Satisfaction Rate', '4.7/5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTaskCompletionChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Completion Rate',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      // showTitles: true,
                      // textStyle: TextStyle(fontSize: 12),
                      // getTitle: (value) {
                      //   switch (value.toInt()) {
                      //     case 0:
                      //       return 'Mon';
                      //     case 1:
                      //       return 'Tue';
                      //     case 2:
                      //       return 'Wed';
                      //     case 3:
                      //       return 'Thu';
                      //     case 4:
                      //       return 'Fri';
                      //     default:
                      //       return '';
                      //   }
                      // },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(fromY: 75, toY: 0, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(fromY: 85,  toY: 0, color: Colors.blue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(fromY: 90, color: Colors.blue, toY: 0)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(fromY: 0, toY: 80, color: Colors.blue)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(fromY: 95, color: Colors.blue, toY: 0)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseTimeChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Response Time',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    // bottomTitles: AxisTitles(
                    //   showTitles: true,
                    //   reservedSize: 22,
                    //   textStyle: (context, value) => const TextStyle(fontSize: 12),
                    //   getTitle: (value) {
                    //     switch (value.toInt()) {
                    //       case 0:
                    //         return 'Mon';
                    //       case 1:
                    //         return 'Tue';
                    //       case 2:
                    //         return 'Wed';
                    //       case 3:
                    //         return 'Thu';
                    //       case 4:
                    //         return 'Fri';
                    //       default:
                    //         return '';
                    //     }
                    //   },
                    // ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 4,
                  minY: 0,
                  maxY: 60,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 30),
                        const FlSpot(1, 35),
                        const FlSpot(2, 25),
                        const FlSpot(3, 40),
                        const FlSpot(4, 28),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

