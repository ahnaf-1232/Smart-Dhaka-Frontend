import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CommunityMapUpdateScreen extends StatefulWidget {
  const CommunityMapUpdateScreen({Key? key}) : super(key: key);

  @override
  _CommunityMapUpdateScreenState createState() => _CommunityMapUpdateScreenState();
}

class _CommunityMapUpdateScreenState extends State<CommunityMapUpdateScreen> {
  final TextEditingController _locationController = TextEditingController();
  final List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Map Update'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'New Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addMarker,
                  child: const Text('Add Point'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(23.8103, 90.4125), // Dhaka coordinates
                zoom: 13.0,
                onTap: (_, LatLng point) {
                  _addMarkerAtPoint(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addMarker() {
    if (_locationController.text.isNotEmpty) {
      // TODO: Implement geocoding to convert location name to coordinates
      // For now, we'll add a marker at a random location near Dhaka
      final random = LatLng(
        23.8103 + (DateTime.now().millisecond - 500) / 10000,
        90.4125 + (DateTime.now().millisecond - 500) / 10000,
      );
      _addMarkerAtPoint(random);
    }
  }

  void _addMarkerAtPoint(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          builder: (ctx) => const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      );
    });
    // TODO: Implement backend logic to save the new point
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New point added to the map')),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}

