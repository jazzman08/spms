import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spms/pages/home_page/booking/ticketDetailsPage.dart';
import 'package:spms/service/database.dart';

class TicketsBookedPage extends StatefulWidget {
  @override
  State<TicketsBookedPage> createState() => _TicketsBookedPageState();
}

class _TicketsBookedPageState extends State<TicketsBookedPage> {
  Stream<QuerySnapshot>? ticketStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  // Fetch tickets being booked using stream from the database
  void getOnLoad() async {
    // Await the Future and get the Stream
    ticketStream = await DatabaseMethods().getTicketDetails(); // Ensure this returns a Stream<QuerySnapshot>
    setState(() {});
  }

  // This function returns a widget that displays the ticket details
  Widget allTicketDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: ticketStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No tickets found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ferry: ${ds["ferry name"]}",
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Type: ${ds["ticket type"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Date: ${ds["date of travel"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Class: ${ds["class of travel"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Price: ${ds["ticket price"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketDetailsPage(
                                ticket: ds.data() as Map<String, dynamic>, // Pass the entire ticket data
                              ),
                            ),
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booked Tickets"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Booked Tickets',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: allTicketDetails()),
          ],
        ),
      ),
    );
  }
}
