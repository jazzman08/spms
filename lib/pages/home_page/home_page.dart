import 'package:flutter/material.dart';
import 'package:spms/pages/home_page/booking/ticketsBooked.dart';
import 'package:spms/pages/home_page/customerProfilePage.dart';
import 'package:spms/pages/home_page/home_features/home_screen.dart';
import 'package:spms/pages/home_page/notification/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Initialize the NotificationService
  final NotificationService _notificationService = NotificationService();

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Pass the notificationService to the NotificationPage
    _widgetOptions = <Widget>[
      const TicketHomeScreen(),
      TicketsBookedPage(),
      // Uncomment if you want to add a notifications page later
      // NotificationPage(notificationService: _notificationService),
      const CustomerProfilePage(customerId: 'exampleCustomerId'), // Replace with real customerId
    ];
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer when an item is selected
  }

  void _logout() {
    // Handle the logout logic here
    Navigator.pushReplacementNamed(context, '/logIn'); // Navigate to the login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Home Page"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, User!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onItemTap(0),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Booking'),
              onTap: () => _onItemTap(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => _onItemTap(2), // Updated to match _widgetOptions index
            ),
            const Divider(), // Divider to separate the logout button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
