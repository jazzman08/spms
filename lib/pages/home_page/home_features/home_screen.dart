import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spms/pages/home_page/payment/payment_page.dart';
import 'package:spms/service/database.dart';

class TicketHomeScreen extends StatefulWidget {
  const TicketHomeScreen({super.key});

  @override
  _TicketHomeScreenState createState() => _TicketHomeScreenState();
}

class _TicketHomeScreenState extends State<TicketHomeScreen> {
  TextEditingController ferrynamecontroller = TextEditingController();
  TextEditingController tickettypecontroller = TextEditingController();
  TextEditingController dateoftravelcontroller = TextEditingController();
  TextEditingController classoftravelcontroller = TextEditingController();
  TextEditingController ticketpricecontroller = TextEditingController();
  Stream<QuerySnapshot>? ticketStream;

  getOnLoad() async {
    ticketStream = await DatabaseMethods().getTicketDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnLoad();
    super.initState();
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
                              builder: (context) => BookTicketPage(
                                ticketId: ds.id,
                                ferryName: ds["ferry name"],
                                ticketType: ds["ticket type"],
                                dateOfTravel: ds["date of travel"],
                                classOfTravel: ds["class of travel"],
                                ticketPrice: ds["ticket price"],
                              ),
                            ),
                          );
                        },
                        child: const Text('Book'),
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
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Welcome',
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
