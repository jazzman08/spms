import 'package:flutter/material.dart';
import 'package:spms/pages/captains/google_map.dart';
import 'package:spms/pages/captains/captainsDashboard.dart';
import 'package:spms/pages/captains/mail/mail_page.dart';
import 'package:spms/pages/captains/radar.dart'; // Import the RadarPage from radar.dart

void main() {
  runApp(CaptainApp());
}

class CaptainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Captain Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CaptainLandingPage(),
    );
  }
}

class CaptainLandingPage extends StatefulWidget {
  @override
  _CaptainLandingPageState createState() => _CaptainLandingPageState();
}

class _CaptainLandingPageState extends State<CaptainLandingPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CaptainDashboardPage(),
    RadarPage(), // RadarPage now imported from radar.dart
    const GoogleMapFlutter(),
    MailPage(),
  ];

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); // Close the drawer after navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captain Dashboard'),
      ),
      body: _pages[_currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => _navigateToPage(0),
            ),
            ListTile(
              leading: Icon(Icons.radar),
              title: Text('Radar'),
              onTap: () => _navigateToPage(1),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Map'),
              onTap: () => _navigateToPage(2),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => _navigateToPage(3),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Notifications Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
