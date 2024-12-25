import 'package:flutter/material.dart';

class RoleAssignmentScreen extends StatefulWidget {
  const RoleAssignmentScreen({Key? key}) : super(key: key);

  @override
  _RoleAssignmentScreenState createState() => _RoleAssignmentScreenState();
}

class _RoleAssignmentScreenState extends State<RoleAssignmentScreen> {
  final List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Resident'},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Service Holder'},
    {'id': 3, 'name': 'Mike Johnson', 'email': 'mike@example.com', 'role': 'Government Authority'},
  ];

  final List<String> roles = ['Resident', 'Service Holder', 'Government Authority', 'Admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Assignment'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(user['name']),
              subtitle: Text(user['email']),
              trailing: DropdownButton<String>(
                value: user['role'],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      user['role'] = newValue;
                    });
                    _updateUserRole(context, user['id'], newValue);
                  }
                },
                items: roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateUserRole(BuildContext context, int userId, String newRole) {
    // TODO: Implement role update logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated role for user #$userId to $newRole')),
    );
  }
}

