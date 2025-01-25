import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_dhaka_app/screens/features/complaint_details.dart';
import 'package:smart_dhaka_app/services/complaint_service.dart';
import 'package:smart_dhaka_app/services/voting_service.dart';

class ComplaintSystemScreen extends StatefulWidget {
  const ComplaintSystemScreen({Key? key}) : super(key: key);

  @override
  _ComplaintSystemScreenState createState() => _ComplaintSystemScreenState();
}

class _ComplaintSystemScreenState extends State<ComplaintSystemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define GlobalKeys for the tabs
  final GlobalKey<_MyComplaintsTabState> myComplaintsKey = GlobalKey();
  final GlobalKey<_AllComplaintsTabState> allComplaintsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Add a listener to refresh data when tabs change
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        myComplaintsKey.currentState?.refreshData();
      } else if (_tabController.index == 2) {
        allComplaintsKey.currentState?.refreshData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint System'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submission'),
            Tab(text: 'My Complaints'),
            Tab(text: 'All Complaints'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ComplaintsSubmissionTab(),
          MyComplaintsTab(key: myComplaintsKey),
          AllComplaintsTab(key: allComplaintsKey),
        ],
      ),
    );
  }
}

class ComplaintsSubmissionTab extends StatefulWidget {
  @override
  _ComplaintsSubmissionTabState createState() =>
      _ComplaintsSubmissionTabState();
}

class _ComplaintsSubmissionTabState extends State<ComplaintsSubmissionTab> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  double? _latitude;
  double? _longitude;
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your present address';
                    }
                    return null;
                  },
                  onSaved: (value) => _address = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Complaint Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.location_on),
                        label: const Text('Get Current Location'),
                      ),
                    ),
                  ],
                ),
                if (_latitude != null && _longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Location: $_latitude, $_longitude',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 24),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     // TODO: Implement image upload functionality
                //   },
                //   icon: const Icon(Icons.upload_file),
                //   label: const Text('Upload Image (Optional)'),
                // ),
                ElevatedButton(
                  onPressed: _submitComplaint,
                  child: const Text('Submit Complaint'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get current location')),
      );
    }
  }

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Retrieve the token from secure storage
        final String? token = await _secureStorage.read(key: 'authToken');

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not authenticated. Please log in again.')),
          );
          return;
        }

        final complaintService =
            ComplaintService(); // Ensure ComplaintService uses the token

        // Call the complaint service with the retrieved token
        await complaintService.submitComplaint(
            _address,
            _latitude!,
            _longitude!,
            _descriptionController.text,
            token // Pass the token to the service
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complaint submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

class MyComplaintsTab extends StatefulWidget {
  const MyComplaintsTab({Key? key}) : super(key: key);

  @override
  _MyComplaintsTabState createState() => _MyComplaintsTabState();
}

class _MyComplaintsTabState extends State<MyComplaintsTab> {
  final ComplaintService _complaintService = ComplaintService();
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      _complaintsFuture = _complaintService.getComplaints(
        getAllComplaints: false,
        getMyComplaints: true,
      );
    });
  }

  void refreshData() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _complaintsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No complaints found.'));
        } else {
          final complaints = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                child: ListTile(
                  title: Text(complaint['description']),
                  subtitle: Text('Status: ${complaint['status']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${complaint['votes']} votes'),
                    ],
                  ),
                  onTap: () {
                    print("complaint: $complaint");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailScreen(complaint: complaint,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class AllComplaintsTab extends StatefulWidget {
  const AllComplaintsTab({Key? key}) : super(key: key);

  @override
  _AllComplaintsTabState createState() => _AllComplaintsTabState();
}

class _AllComplaintsTabState extends State<AllComplaintsTab> {
  final ComplaintService _complaintService = ComplaintService();
  final VoteService _voteService = VoteService();
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      _complaintsFuture = _complaintService.getComplaints(
        getAllComplaints: true,
        getMyComplaints: false,
      );
    });
  }

  void refreshData() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _complaintsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No complaints found.'));
        } else {
          final complaints = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final hasVoted =
                  complaint['hasVoted'] ?? false;

              return Card(
                child: ListTile(
                  title: Text(complaint['description']),
                  subtitle: Text('Status: ${complaint['status']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${complaint['votes']} votes'),
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: hasVoted ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          if (!hasVoted) {
                            print(complaint);
                            _voteForComplaint(complaint['_id']);
                          } else {
                            _removeVoteForComplaint(complaint['_id']);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailScreen(complaint: complaint,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _voteForComplaint(String complaintId) async {
    try {
      await _voteService.vote("Complaint", complaintId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote registered successfully!')),
      );
      refreshData(); // Refresh data after voting
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register vote: $error')),
      );
    }
  }

  Future<void> _removeVoteForComplaint(String complaintId) async {
    try {
      await _voteService.removeVote("Complaint", complaintId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote deregistered successfully!')),
      );
      refreshData(); // Refresh data after voting
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deregister vote: $error')),
      );
    }
  }
}
