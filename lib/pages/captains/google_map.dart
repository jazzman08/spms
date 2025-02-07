import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  // Default initial location (latitude and longitude)
  LatLng myCurrentLocation = const LatLng(27.7172, 85.3240); // Default Kathmandu, Nepal
  late GoogleMapController googleMapController; // Controller for Google Maps
  Set<Marker> markers = {}; // Set to store map markers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps in Flutter'),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        myLocationEnabled: true, // Show user's current location on the map
        myLocationButtonEnabled: true, // Enable my-location button
        markers: markers, // Display markers on the map
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller; // Assign the controller when the map is created
        },
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation, // Initial camera position
          zoom: 14, // Initial zoom level
        ),
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

            // Clear existing markers
            markers.clear();

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
            // Handle errors gracefully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $e")),
            );
          }
        },
      ),
    );
  }

  // Function to get the user's current position
  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable them.';
    }

    // Check location permission
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

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
