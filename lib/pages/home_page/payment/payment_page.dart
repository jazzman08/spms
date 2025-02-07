import 'package:flutter/material.dart';
import 'package:spms/pages/home_page/payment/stripePay.dart';

class BookTicketPage extends StatefulWidget {
  final String ticketId;
  final String ferryName;
  final String ticketType;
  final String dateOfTravel;
  final String classOfTravel;
  final String ticketPrice;

  // Constructor accepting the required parameters
  const BookTicketPage({
    super.key,
    required this.ticketId,
    required this.ferryName,
    required this.ticketType,
    required this.dateOfTravel,
    required this.classOfTravel,
    required this.ticketPrice,
  });

  @override
  State<BookTicketPage> createState() => _BookTicketPageState();
}

class _BookTicketPageState extends State<BookTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Ticket for ${widget.ferryName}'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ferry: ${widget.ferryName}'),
            Text('Ticket Type: ${widget.ticketType}'),
            Text('Date of Travel: ${widget.dateOfTravel}'),
            Text('Class of Travel: ${widget.classOfTravel}'),
            Text('Price: ${widget.ticketPrice}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show the SnackBar notification
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proceeding to payment...')),
                );

                // Create a map of ticket details
                final ticketDetails = {
                  'ticketId': widget.ticketId,
                  'ferryName': widget.ferryName,
                  'ticketType': widget.ticketType,
                  'dateOfTravel': widget.dateOfTravel,
                  'classOfTravel': widget.classOfTravel,
                  'ticketPrice': double.parse(widget.ticketPrice), // Convert to double if needed
                };

                // Navigate to the payment page and pass ticket details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Stripepay(ticketDetails: ticketDetails),
                  ),
                );
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
