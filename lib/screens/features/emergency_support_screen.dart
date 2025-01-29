import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_dhaka_app/services/emergnecy_service.dart';

class EmergencySupportScreen extends StatefulWidget {
  const EmergencySupportScreen({Key? key}) : super(key: key);

  @override
  _EmergencySupportScreenState createState() => _EmergencySupportScreenState();
}

class _EmergencySupportScreenState extends State<EmergencySupportScreen>
    with SingleTickerProviderStateMixin {
  final EmergencyService _emergencyService = EmergencyService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Emergency Support'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Request Service'),
            Tab(text: 'Requested Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestServiceTab(),
          _buildRequestedServicesTab(),
        ],
      ),
    );
  }

  Widget _buildRequestServiceTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select Emergency Type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _findNearestServiceStation(context, 'Hospital'),
            icon: const Icon(Icons.local_hospital),
            label: const Text('Hospital'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _findNearestServiceStation(context, 'Police'),
            icon: const Icon(Icons.local_police),
            label: const Text('Police'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _findNearestServiceStation(context, 'Fire Service'),
            icon: const Icon(Icons.local_fire_department),
            label: const Text('Fire'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestedServicesTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _emergencyService.getRequestedServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No requested services.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final service = snapshot.data![index];
              final bool isClosed = service['status'] == 'Closed';
              return Card(
                // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                      'Service Holder: ${service['serviceHolder']['name']}'),
                  subtitle: Text(
                      'Service Type: ${service['serviceHolder']['serviceType']} \nStatus: ${service['status']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    color: isClosed ? Colors.green : null, // Green if closed
                    onPressed: isClosed
                        ? null // Disable button if already closed
                        : () => _closeService(context, service['_id']),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _findNearestServiceStation(
      BuildContext context, String serviceType) async {
    try {
      final Position position = await _getUserLocation();
      final response = await _emergencyService.findNearestService(
        serviceType,
        position.latitude,
        position.longitude,
      );
      _showNearestServiceStation(
        context,
        serviceType,
        response['name'],
        response['distance'],
        response['_id'],
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them from app settings.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void _showNearestServiceStation(
    BuildContext context,
    String serviceType,
    String name,
    double distance,
    String serviceHolderId,
    double userLat,
    double userLng,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nearest $serviceType Station'),
          content: Text(
            'The nearest $serviceType station is $name, located $distance km away.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _requestSupport(
                    context, serviceHolderId, userLat, userLng);
              },
              child: const Text('Request Support'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestSupport(BuildContext context, String serviceHolderId,
      double userLat, double userLng) async {
    try {
      await _emergencyService.createEmergencyRequest(
        serviceHolderId,
        userLat,
        userLng,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support requested successfully!')),
      );
      setState(() {
        _tabController.index = 1; // Switch to the Requested Services tab
      });
    } catch (e) {
      _showErrorDialog(context, 'Failed to request support: $e');
    }
  }

  void _showServiceDetails(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${service['serviceType']} Service Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${service['status']}'),
              Text('Service Holder: ${service['serviceHolderName']}'),
              Text('Requested at: ${service['requestedAt']}'),
              // Add more details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (service['status'] != 'Closed')
              TextButton(
                onPressed: () async {
                  await _closeService(context, service['_id']);
                  Navigator.of(context).pop();
                },
                child: const Text('Close Service'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _closeService(BuildContext context, String serviceId) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Close Service'),
          content: const Text('Are you sure the service is completed? Once closed, it cannot be reopened.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog

                // Call the closeEmergencyRequest API
                try {
                  await _emergencyService.closeEmergencyRequest(serviceId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Service closed successfully!')),
                  );
                  setState(() {}); // Refresh the list
                } catch (e) {
                  _showErrorDialog(context, 'Failed to close service: $e');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
