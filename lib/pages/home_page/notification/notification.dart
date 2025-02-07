import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spms/pages/home_page/notification/notification_service.dart';
import 'package:spms/pages/home_page/location_service.dart';

class NotificationPage extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationPage({Key? key, required this.notificationService})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final LocationService _locationService = LocationService();

  Future<void> _setupLocationNotification() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      await widget.notificationService.showNotification(
        id: 1,
        title: 'Location Update',
        body: 'Your current location: (${position.latitude}, ${position.longitude})',
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendCargoShipmentNotification() async {
    await widget.notificationService.showNotification(
      id: 2,
      title: 'Cargo Shipment Update',
      body: 'Your shipment #12345 has been dispatched!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _setupLocationNotification,
              child: const Text('Get Location Update'),
            ),
            ElevatedButton(
              onPressed: _sendCargoShipmentNotification,
              child: const Text('Send Shipment Update'),
            ),
          ],
        ),
      ),
    );
  }
}
