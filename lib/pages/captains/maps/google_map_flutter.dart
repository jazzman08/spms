import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation = const LatLng(27.7172, 85.3240); // Default Kathmandu, Nepal
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  late WebSocketChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    // WebSocket connection to the backend
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));

    // Initialize notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();

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

  // Initialize the local notifications plugin
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to show a notification
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'vessel_notifications_channel', // Channel ID
      'Vessel Notifications', // Channel name
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Vessel Location Update',
      message, // Notification content
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Port Vessel Tracker'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Container to change the height of the map
          Container(
            height: 300, // Set the height for the map
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: myCurrentLocation,
                zoom: 14,
              ),
            ),
          ),
          // Padding around the button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: updateVesselLocations,
              child: const Text('Update Vessel Locations'),
            ),
          ),
          // Additional space to prevent overlapping of elements
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.my_location,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            // Get the user's current position
            Position position = await currentPosition();

            // Update the camera to the user's location
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
              ),
            );

            // Add a marker for the user's current location
            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(
                  title: "Your Location",
                ),
              ),
            );

            // Refresh the UI
            setState(() {});
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $e")),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            // Get the current position
            Position position = await currentPosition();

            // Send notification with coordinates
            String message =
                'Current Location: Latitude ${position.latitude}, Longitude ${position.longitude}';
            _showNotification(message);
          },
          child: const Text('Send Current Location as Notification'),
        ),
      ),
    );
  }

  // Function to get the user's current position
  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable them.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied. Enable them from settings.';
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Function to manually update vessel locations from WebSocket
  void updateVesselLocations() {
    // Triggering WebSocket again to fetch the latest data
    channel.sink.add('fetch_vessel_data'); // Example message to request data from the backend
  }
}
