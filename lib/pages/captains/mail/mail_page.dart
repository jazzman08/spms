import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() {
  runApp(MailPageApp());
}

class MailPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MailPage(),
    );
  }
}

class MailPage extends StatelessWidget {
  // Email sending function
  Future<void> sendEmail() async {
    final Email email = Email(
      body: 'Dear Users,\n\nThis is an important message from the captain. Please stay updated!',
      subject: 'Important Update from the Captain',
      recipients: ['cpahbz@gmail.com', ], // Replace with actual user emails
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      print("Email sent successfully!");
    } catch (error) {
      print("Failed to send email: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendEmail,
          child: Text('Send Email to Users'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
