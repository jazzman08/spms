import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminUserPage extends StatefulWidget {
  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a user to Firebase Authentication and Firestore
  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the UID of the created user
        String uid = userCredential.user!.uid;

        // Add user details to Firestore
        await _firestore.collection('Users').doc(uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'role': _roleController.text,
          'created_at': FieldValue.serverTimestamp(),
        });

        // Clear form fields
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
        _roleController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Form for adding new users
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Name is required' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Email is required' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password is required' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Role is required' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: Text('Add User'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Expanded section for displaying the table of users
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Users')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }

                  final users = snapshot.data!.docs;

                  return DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      DataColumn(
                        label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      DataColumn(
                        label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      DataColumn(
                        label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user['name'], style: TextStyle(fontSize: 16))),
                          DataCell(Text(user['email'], style: TextStyle(fontSize: 16))),
                          DataCell(Text(user['role'], style: TextStyle(fontSize: 16))),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Add edit functionality here
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Add delete functionality here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
