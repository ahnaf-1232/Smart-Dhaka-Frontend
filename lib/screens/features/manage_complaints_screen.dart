import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/complaint_details.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({Key? key}) : super(key: key);

  @override
  _ManageComplaintsScreenState createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  final List<Map<String, dynamic>> _complaints = [
    {'id': 1, 'title': 'Pothole on Main Street', 'status': 'Pending', 'priority': 'High'},
    {'id': 2, 'title': 'Broken streetlight near City Park', 'status': 'In Progress', 'priority': 'Medium'},
    {'id': 3, 'title': 'Garbage not collected on time', 'status': 'Resolved', 'priority': 'Low'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Complaints'),
      ),
      body: ListView.builder(
        itemCount: _complaints.length,
        itemBuilder: (context, index) {
          final complaint = _complaints[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(complaint['title']),
              subtitle: Text('Status: ${complaint['status']} | Priority: ${complaint['priority']}'),
              trailing: PopupMenuButton<String>(
                onSelected: (String result) {
                  _handleComplaintAction(result, complaint['id']);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'view',
                    child: Text('View Details'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'update',
                    child: Text('Update Status'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'assign',
                    child: Text('Assign to Department'),
                  ),
                ],
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ComplaintDetailScreen(
              //         complaint: complaint,
              //       ),
              //     ),
              //   );
              // },
            ),
          );
        },
      ),
    );
  }

  void _handleComplaintAction(String action, int complaintId) {
    // TODO: Implement actions for viewing details, updating status, and assigning to department
    switch (action) {
      case 'view':
        _viewComplaintDetails(complaintId);
        break;
      case 'update':
        _updateComplaintStatus(complaintId);
        break;
      case 'assign':
        _assignComplaintToDepartment(complaintId);
        break;
    }
  }

  void _viewComplaintDetails(int complaintId) {
    // TODO: Implement viewing complaint details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for complaint #$complaintId')),
    );
  }

  void _updateComplaintStatus(int complaintId) {
    // TODO: Implement updating complaint status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updating status for complaint #$complaintId')),
    );
  }

  void _assignComplaintToDepartment(int complaintId) {
    // TODO: Implement assigning complaint to department
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Assigning complaint #$complaintId to department')),
    );
  }

  void _addNewComplaint() {
    // TODO: Implement adding a new complaint
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding a new complaint')),
    );
  }
}

