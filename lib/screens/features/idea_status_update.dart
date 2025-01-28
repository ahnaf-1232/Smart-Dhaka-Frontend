import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/services/complaint_service.dart';
import 'package:smart_dhaka_app/services/idea_service.dart';

class IdeaStatusUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> idea;

  const IdeaStatusUpdateScreen({Key? key, required this.idea}) : super(key: key);

  @override
  _IdeaStatusUpdateScreenState createState() => _IdeaStatusUpdateScreenState();
}

class _IdeaStatusUpdateScreenState extends State<IdeaStatusUpdateScreen> {
  late String _currentStatus;
  final List<String> _statusOptions = ['Pending', 'In Progress', 'Resolved', 'Closed'];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.idea['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Idea Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Idea: ${widget.idea['title']}',
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
      final response = await IdeaService().updateIdeaStatus(
        widget.idea['_id'],
        _currentStatus,
      );

      Navigator.of(context).pop(); // Close the loading dialog
      print(response);

      if (response['status'] == 200) {
        // Update the complaint status locally
        widget.idea['status'] = _currentStatus;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully')),
        );

        // Return to the previous screen with the updated complaint data
        Navigator.of(context).pop(widget.idea);
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
