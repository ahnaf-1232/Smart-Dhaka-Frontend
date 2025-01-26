import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/complaint_details.dart';
import 'package:smart_dhaka_app/screens/features/complaint_status_update.dart';
import 'package:smart_dhaka_app/services/complaint_service.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({Key? key}) : super(key: key);

  @override
  _ManageComplaintsScreenState createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  late ComplaintService _complaintService;
  List<Map<String, dynamic>> _complaints = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _complaintService = ComplaintService();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final complaints = await _complaintService.fetchComplaintsForAuthority();
      print(complaints);
      setState(() {
        _complaints = complaints;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching complaints: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Complaints'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _complaints.isEmpty
              ? const Center(child: Text('No complaints available'))
              : ListView.builder(
                  itemCount: _complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = _complaints[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(complaint['title']),
                        subtitle: Text(
                          'Status: ${complaint['status']} | Priority: ${complaint['priority']}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String result) {
                            _handleComplaintAction(result, complaint);
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'update',
                              child: Text('Update Status'),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComplaintDetailScreen(
                                complaint: complaint,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _handleComplaintAction(String action, dynamic complaint) {
    switch (action) {
      case 'view':
        _viewComplaintDetails(complaint);
        break;
      case 'update':
        _updateComplaintStatus(complaint);
        break;
    }
  }

  void _viewComplaintDetails(dynamic complaint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailScreen(
          complaint: complaint,
        ),
      ),
    );
  }

  void _updateComplaintStatus(Map<String, dynamic> complaint) async {
    final updatedComplaint = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintStatusUpdateScreen(complaint: complaint),
      ),
    );

    if (updatedComplaint != null) {
      setState(() {
        final index =
            _complaints.indexWhere((c) => c['id'] == updatedComplaint['id']);
        if (index != -1) {
          _complaints[index] = updatedComplaint;
        }
      });
    }
  }
}
