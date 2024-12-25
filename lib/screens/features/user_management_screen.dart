import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Resident'},
      {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Service Holder'},
      {'id': 3, 'name': 'Mike Johnson', 'email': 'mike@example.com', 'role': 'Government Authority'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(user['name']),
              subtitle: Text('${user['email']} | ${user['role']}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editUser(context, user['id']),
              ),
              onTap: () => _viewUserDetails(context, user['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editUser(BuildContext context, int userId) {
    // TODO: Implement user editing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing user #$userId')),
    );
  }

  void _viewUserDetails(BuildContext context, int userId) {
    // TODO: Implement user details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for user #$userId')),
    );
  }

  void _addNewUser(BuildContext context) {
    // TODO: Implement add new user functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding a new user')),
    );
  }
}

