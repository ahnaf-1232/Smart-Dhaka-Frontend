import 'package:flutter/material.dart';

class AssignedTasksScreen extends StatelessWidget {
  const AssignedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {'id': 1, 'title': 'Fix pothole on Main Street', 'priority': 'High', 'dueDate': '2023-05-20'},
      {'id': 2, 'title': 'Replace streetlight near City Park', 'priority': 'Medium', 'dueDate': '2023-05-22'},
      {'id': 3, 'title': 'Clean drainage system on 5th Avenue', 'priority': 'Low', 'dueDate': '2023-05-25'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(task['title']),
              subtitle: Text('Priority: ${task['priority']} | Due: ${task['dueDate']}'),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => _markTaskAsComplete(context, task['id']),
              ),
              onTap: () => _viewTaskDetails(context, task['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _markTaskAsComplete(BuildContext context, int taskId) {
    // TODO: Implement task completion logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked task #$taskId as complete')),
    );
  }

  void _viewTaskDetails(BuildContext context, int taskId) {
    // TODO: Implement task details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for task #$taskId')),
    );
  }

  void _addNewTask(BuildContext context) {
    // TODO: Implement add new task functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding a new task')),
    );
  }
}

