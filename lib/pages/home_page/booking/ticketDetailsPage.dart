import 'package:flutter/material.dart';

class TicketDetailsPage extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsPage({required this.ticket, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ticket['ferry name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket Type: ${ticket['ticket type']}'),
            Text('Date of Travel: ${ticket['date of travel']}'),
            Text('Class of Travel: ${ticket['class of travel']}'),
            Text('Ticket Price: ${ticket['ticket price']}'),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
