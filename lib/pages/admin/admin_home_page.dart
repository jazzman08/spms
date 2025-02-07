import 'package:flutter/material.dart';
import 'package:spms/pages/admin/Report/InputReportPage.dart';
import 'package:spms/pages/admin/contentPage.dart';
import 'package:spms/pages/admin/settings.dart';

import 'add_ticket.dart'; // Import your pages
import 'manage_users_page.dart'; // Import the users page

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  // Add placeholder widgets for pages not implemented
  static final List<Widget> _widgetOptions = <Widget>[
    AddTicket(),
    AdminUserPage(), // Add your users page here
    AdminResourcesPage(), // Placeholder for "Content" page
    InputReportPage(), // Placeholder for "Reports" page
    AdminSettingsPage(), // Placeholder for "Settings" page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close the drawer after selecting an item
    });
  }

  // Logout function
  void _logout() {
    // Handle your logout logic here (e.g., clearing session, etc.)
    Navigator.pushReplacementNamed(context, '/logIn'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Add Tickets'
              : _selectedIndex == 1
                  ? 'Manage Users'
                  : 'Admin Page', // Update title dynamically
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle sign-out action
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Tickets'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: const Text('Content'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reports'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _onItemTapped(4),
            ),
            const Divider(), // Optional divider between menu and logout
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: _logout, // Call logout function when tapped
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
