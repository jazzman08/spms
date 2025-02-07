import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerProfilePage extends StatefulWidget {
  final String customerId; // Pass customer ID to load the profile dynamically

  const CustomerProfilePage({super.key, required this.customerId});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> customerData;

  @override
  void initState() {
    super.initState();
    // Fetch customer data from Firestore
    customerData = FirebaseFirestore.instance
        .collection('Customers')
        .doc(widget.customerId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Profile"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: customerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return const Center(child: Text("Customer profile not found."));
          }

          // Extract customer data
          final data = snapshot.data!.data()!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(data['profilePictureUrl'] ?? ''),
                  child: data['profilePictureUrl'] == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  "Name: ${data['name']}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Email: ${data['email']}"),
                const SizedBox(height: 8),
                Text("Phone: ${data['phone']}"),
                const SizedBox(height: 8),
                Text("Membership: ${data['membershipType']}"),
                const Divider(height: 32),
                Text(
                  "Booking History:",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('BookedTickets')
                        .where('customerId', isEqualTo: widget.customerId)
                        .orderBy('bookingTime', descending: true)
                        .snapshots(),
                    builder: (context, bookingSnapshot) {
                      if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!bookingSnapshot.hasData || bookingSnapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No bookings found."));
                      }

                      return ListView.builder(
                        itemCount: bookingSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final booking = bookingSnapshot.data!.docs[index].data();
                          return Card(
                            child: ListTile(
                              title: Text("Ferry: ${booking['ferryName']}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date: ${booking['dateOfTravel']}"),
                                  Text("Class: ${booking['classOfTravel']}"),
                                  Text("Price: ${booking['ticketPrice']} USD"),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
