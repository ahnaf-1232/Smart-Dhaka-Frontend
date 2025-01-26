import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ShortestPathScreen extends StatefulWidget {
  const ShortestPathScreen({Key? key}) : super(key: key);

  @override
  _ShortestPathScreenState createState() => _ShortestPathScreenState();
}

class _ShortestPathScreenState extends State<ShortestPathScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for TextField
  String _selectedCategory = ''; // Selected category
  List<String> _categories = []; // List of categories
  List<Map<String, dynamic>> allNodes = [];
  Position? _currentPosition;
  bool _isLoading = false;
  LatLng? _destinationPosition;
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Map<String, dynamic>> nodeSuggestions = [];
  String? _selectedEntityName;
  bool _isEntityBoxMinimized = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location
    _loadLocalData(); // Load node data into memory
    _loadCategories(); // Load categories into memory

    // Listen to focus changes and clear suggestions when losing focus
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          nodeSuggestions = [];
        });
      }
    });
  }

  Future<void> _loadCategories() async {
    try {
      // Load the categories.json file
      final String jsonString =
          await rootBundle.loadString('assets/data/categories.json');
      final List<dynamic> data = json.decode(jsonString);

      setState(() {
        _categories = List<String>.from(data);
        if (_categories.isNotEmpty) {
          _selectedCategory =
              _categories.first; // Select the first category by default
        }
      });

      print(
          'Categories loaded successfully: ${_categories.length} categories.');
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
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

  Future<void> _loadLocalData() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle
          .loadString('assets/data/processed_location_serching_data.json');
      final List<dynamic> data = json.decode(jsonString);

      setState(() {
        allNodes = List<Map<String, dynamic>>.from(data);
      });
      print('Data loaded successfully: ${allNodes.length} nodes loaded.');
    } catch (e) {
      print('Error loading local JSON data: $e');
    }
  }

  void _filterNodes(String query) {
    setState(() {
      nodeSuggestions = allNodes.where((node) {
        final name = node['name']?.toLowerCase() ?? '';
        final nameEn = node['name:en']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            nameEn.contains(query.toLowerCase());
      }).toList();
      print(nodeSuggestions);
    });
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) {
      print('Current location not available.');
      return;
    }

    print(
        'Fetching nearby places for category: $_selectedCategory, Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://10.100.201.63:5000/nearest-entity?category=$_selectedCategory&lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Nearby places fetched successfully: ${data} places.');

        // Extract path coordinates from the response
        final List<dynamic> path = data['path'] ?? [];
        final dynamic selectedEntity = data['nearest_entity'];
        final List<LatLng> pathCoordinates = path.map((node) {
          return LatLng(node['latitude'], node['longitude']);
        }).toList();

        // Update the state to display the path
        setState(() {
          polylines = [
            Polyline(
              points: pathCoordinates,
              strokeWidth: 4.0,
              color: Colors.green,
            )
          ];
          _destinationPosition = LatLng(
            selectedEntity["lat"],
            selectedEntity["lng"],
          );
          _selectedEntityName = selectedEntity["name"];
        });
      } else {
        print(
            'Failed to fetch nearby places. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearby places: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchShortestPath() async {
    if (_currentPosition == null || _destinationPosition == null) {
      print('Location or destination not set.');
      return;
    }

    final originLat = _currentPosition!.latitude;
    final originLon = _currentPosition!.longitude;
    final destinationLat = _destinationPosition!.latitude;
    final destinationLon = _destinationPosition!.longitude;

    print(
        'Origin: $originLat, $originLon, Destination: $destinationLat, $destinationLon');

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Call the API
      final response = await http.get(Uri.parse(
          'http://10.100.201.63:5000/shortest-paths?origin_lat=$originLat&origin_lon=$originLon&target_lat=$destinationLat&target_lon=$destinationLon'));

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);

        // Extract path coordinates from the response
        final List<dynamic> path = data['path'] ?? [];
        final List<LatLng> pathCoordinates = path.map((node) {
          return LatLng(node['latitude'], node['longitude']);
        }).toList();

        // Update the state to display the path
        setState(() {
          polylines = [
            Polyline(
              points: pathCoordinates,
              strokeWidth: 4.0,
              color: Colors.green,
            )
          ];
        });

        print('Path fetched successfully: ${pathCoordinates.length} points.');
      } else {
        print(
            'Failed to fetch shortest path. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching shortest path: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Map'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _destinationController,
                          focusNode: _searchFocusNode,
                          onChanged: (value) => _filterNodes(value),
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
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                            _fetchNearbyPlaces();
                          });
                        },
                        items: _categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                if (nodeSuggestions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: nodeSuggestions.length,
                      itemBuilder: (context, index) {
                        final node = nodeSuggestions[index];
                        return ListTile(
                          title: Text(node["name"]),
                          subtitle: Text(node["name:en"]),
                          onTap: () {
                            setState(() {
                              _destinationController.text = node["name"];
                              _destinationPosition = LatLng(
                                node["lat"],
                                node["lng"],
                              );
                              nodeSuggestions = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude)
                          : LatLng(23.8103, 90.4125),
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
                          if (_currentPosition != null)
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              builder: (ctx) => const Icon(Icons.location_on,
                                  color: Colors.blue, size: 40.0),
                            ),
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
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        if (_selectedEntityName != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isEntityBoxMinimized ? 50 : 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEntityBoxMinimized = !_isEntityBoxMinimized;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isEntityBoxMinimized
                                ? 'See the Name'
                                : 'Selected $_selectedCategory',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(
                            _isEntityBoxMinimized
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!_isEntityBoxMinimized)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Name: ${_selectedEntityName!}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
