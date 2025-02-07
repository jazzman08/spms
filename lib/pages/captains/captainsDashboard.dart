import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CaptainDashboardPage extends StatefulWidget {
  const CaptainDashboardPage({super.key});

  @override
  State<CaptainDashboardPage> createState() => _CaptainDashboardPageState();
}

class _CaptainDashboardPageState extends State<CaptainDashboardPage> {
  late WebSocketChannel channel;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    // WebSocket connection to the backend
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));

    // Listen for real-time vessel updates from WebSocket
    channel.stream.listen((data) {
      var vesselData = json.decode(data);
      setState(() {
        markers.clear();
        for (var vessel in vesselData) {
          markers.add(
            Marker(
              markerId: MarkerId(vessel['id']),
              position: LatLng(vessel['latitude'], vessel['longitude']),
              infoWindow: InfoWindow(title: vessel['name']),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close(); // Close the WebSocket connection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the map page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(markers: markers),
                    ),
                  );
                },
                child: const Text('Go to Map Page'),
              ),
            ),
            Container(
              height: 200, // Constrained height for list view
              child: ListView.builder(
                itemCount: markers.length, // Example: number of vessels
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Vessel ${index + 1}'),
                    subtitle: Text(
                        'Location: ${markers.elementAt(index).position.latitude}, ${markers.elementAt(index).position.longitude}'),
                    trailing: Icon(Icons.info),
                    onTap: () {
                      // Action when tapping on a vessel
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Vessel ${index + 1} Details'),
                          content: Text(
                              'Location: ${markers.elementAt(index).position.latitude}, ${markers.elementAt(index).position.longitude}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  final Set<Marker> markers;

  const MapPage({super.key, required this.markers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          // Additional map functionalities can go here
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(27.7172, 85.3240), // Example default position
          zoom: 14,
        ),
      ),
    );
  }
}
