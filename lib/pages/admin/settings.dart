import 'package:flutter/material.dart';

class AdminSettingsPage extends StatefulWidget {
  @override
  _AdminSettingsPageState createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String _adminName = '';
  String _adminEmail = '';
  String _newPassword = '';
  // ignore: unused_field
  String _confirmPassword = '';

  // Function to update settings (could be linked to a backend)
  void _updateSettings() {
    if (_formKey.currentState!.validate()) {
      // Handle the settings update logic (e.g., make a network call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Settings updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Admin Name
              TextFormField(
                initialValue: _adminName,
                decoration: InputDecoration(
                  labelText: 'Admin Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _adminName = value!,
              ),
              SizedBox(height: 16),

              // Admin Email
              TextFormField(
                initialValue: _adminEmail,
                decoration: InputDecoration(
                  labelText: 'Admin Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _adminEmail = value!,
              ),
              SizedBox(height: 16),

              // New Password
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
                onSaved: (value) => _newPassword = value!,
              ),
              SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value!,
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _updateSettings,
                child: Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
