import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ShortestPathScreen extends StatefulWidget {
  const ShortestPathScreen({Key? key}) : super(key: key);

  @override
  _ShortestPathScreenState createState() => _ShortestPathScreenState();
}

class _ShortestPathScreenState extends State<ShortestPathScreen> {
  final TextEditingController _destinationController = TextEditingController();
  List<Map<String, dynamic>> nodeSuggestions = []; // Node search suggestions
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  Position? _currentPosition; // Store the user's current position
  LatLng? _destinationPosition; // Store the user's entered destination

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location when the app starts
  }

  Future<void> _getCurrentLocation() async {
    // Request permission for location
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    // Fetch the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNodeSuggestions(String query) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.100.201.63:5000/map-data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final nodes = (data['nodes'] as List<dynamic>).map((node) => {
              "name": node["name"],
              "latitude": node["latitude"],
              "longitude": node["longitude"],
            });

        setState(() {
          nodeSuggestions = nodes
              .where((node) =>
                  node["name"].toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      } else {
        throw Exception('Failed to load map data.');
      }
    } catch (e) {
      print('Error fetching node suggestions: $e');
    }
  }

  Future<void> _fetchShortestPath() async {
    try {
      if (_currentPosition == null) {
        print('Current location not available.');
        return;
      }

      // Get current location as origin
      final originLat = _currentPosition!.latitude;
      final originLon = _currentPosition!.longitude;

      if (_destinationPosition == null) {
        print('Destination not set.');
        return;
      }

      final destinationLat = _destinationPosition!.latitude;
      final destinationLon = _destinationPosition!.longitude;

      print(
          'Origin: $originLat, $originLon, Destination: $destinationLat, $destinationLon');

      final response = await http.get(Uri.parse(
          'http://10.100.201.63:5000/shortest-paths?origin_lat=$originLat&origin_lon=$originLon&target_lat=$destinationLat&target_lon=$destinationLon'));

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print(data['path']); // This is a list of nodes

        setState(() {
          polylines = [
            Polyline(
              points: (data['path'] as List<dynamic>)
                  .map((node) => LatLng(node['latitude'], node['longitude']))
                  .toList(),
              strokeWidth: 4.0,
              color: Colors.green,
            )
          ];
          print(polylines);
        });
      } else {
        throw Exception('Failed to load shortest path data');
      }
    } catch (e) {
      print('Error fetching shortest path: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortest Path'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _destinationController,
                  onChanged: (value) {
                    _fetchNodeSuggestions(value); // Fetch node suggestions
                  },
                  decoration: InputDecoration(
                    labelText: 'Search for Destination Node',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _fetchShortestPath();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                if (nodeSuggestions.isNotEmpty)
                  SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      itemCount: nodeSuggestions.length,
                      itemBuilder: (context, index) {
                        final node = nodeSuggestions[index];
                        return ListTile(
                          title: Text(node["name"]),
                          onTap: () {
                            // Set destination position when a node is selected
                            setState(() {
                              _destinationController.text = node["name"];
                              _destinationPosition = LatLng(
                                node["latitude"],
                                node["longitude"],
                              );
                              nodeSuggestions = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _currentPosition != null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : LatLng(23.8103, 90.4125), // Default to Dhaka coordinates
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // Current Location Marker
                    if (_currentPosition != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                            _currentPosition!.latitude, _currentPosition!.longitude),
                        builder: (ctx) => const Icon(Icons.location_on,
                            color: Colors.blue, size: 40.0),
                      ),
                    // Destination Marker
                    if (_destinationPosition != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _destinationPosition!,
                        builder: (ctx) => const Icon(Icons.flag,
                            color: Colors.red, size: 40.0),
                      ),
                    ...markers,
                  ],
                ),
                PolylineLayer(
                  polylines: polylines,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
