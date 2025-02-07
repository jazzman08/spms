import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spms/pages/home_page/booking/ticketsBooked.dart';
import 'package:spms/stripe/stripe_services/stripe_services.dart';

class Stripepay extends StatefulWidget {
  final Map<String, dynamic> ticketDetails; // Pass ticket details to this page

  const Stripepay({super.key, required this.ticketDetails});

  @override
  State<Stripepay> createState() => _StripepayState();
}

class _StripepayState extends State<Stripepay> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == "TicketsBookedPage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TicketsBookedPage()),
          );
        }
      },
    );
  }

  Future<void> _sendNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Booking Successful',
      'Your ticket has been booked successfully!',
      notificationDetails,
      payload: 'TicketsBookedPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketDetails = widget.ticketDetails;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stripe Payment"),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                try {
                  // Get the ticket price dynamically
                  double ticketPrice = ticketDetails['ticketPrice'];
                  String currency = 'usd';

                  // Call makePayment
                  await StripeServices.instance.makePayment(
                    amount: ticketPrice,
                    currency: currency,
                  );

                  // Store ticket details in Firebase after payment
                  FirebaseFirestore.instance.collection('BookedTickets').add({
                    ...ticketDetails,
                    'status': 'Booked',
                    'bookingTime': FieldValue.serverTimestamp(),
                  });

                  // Send push notification
                  await _sendNotification();

                  // Navigate to booked tickets page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketsBookedPage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Failed! Please try again.')),
                  );
                }
              },
              color: Colors.blueGrey,
              child: const Text("Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
