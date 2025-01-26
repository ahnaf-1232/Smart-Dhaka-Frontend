import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/complaint_service.dart';

class ComplaintStatusUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> complaint;

  const ComplaintStatusUpdateScreen({Key? key, required this.complaint}) : super(key: key);

  @override
  _ComplaintStatusUpdateScreenState createState() => _ComplaintStatusUpdateScreenState();
}

class _ComplaintStatusUpdateScreenState extends State<ComplaintStatusUpdateScreen> {
  late String _currentStatus;
  final List<String> _statusOptions = ['Pending', 'In Progress', 'Resolved', 'Closed'];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.complaint['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Complaint Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint: ${widget.complaint['title']}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              'Current Status: $_currentStatus',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'New Status',
                border: OutlineInputBorder(),
              ),
              value: _currentStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentStatus = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateStatus,
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus() async {
    print('Updating status to: $_currentStatus');
    try {
      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Call the ComplaintService to update the status
      final response = await ComplaintService().updateComplaintStatus(
        widget.complaint['_id'],
        _currentStatus,
      );

      Navigator.of(context).pop(); // Close the loading dialog
      print(response);

      if (response['status'] == 200) {
        // Update the complaint status locally
        widget.complaint['status'] = _currentStatus;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully')),
        );

        // Return to the previous screen with the updated complaint data
        Navigator.of(context).pop(widget.complaint);
      } else {
        throw Exception(response['message'] ?? 'Failed to update status.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
