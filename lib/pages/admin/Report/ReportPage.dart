import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to download report as PDF
  Future<void> _downloadReport(BuildContext context, String reportId) async {
    final report = await _firestore.collection('reports').doc(reportId).get();
    final doc = pw.Document();

    // Create PDF content
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Report: $reportId', style: pw.TextStyle(fontSize: 24)),
              pw.Text('Ship Arrivals: ${report['total_ship_arrivals']}'),
              pw.Text('Ship Departures: ${report['total_ship_departures']}'),
              pw.Text('Tickets Booked: ${report['number_of_tickets_booked']}'),
              pw.Text('Total Revenue: \$${report['total_revenue']}'),
              pw.Text('Operational Alerts: ${report['operational_alerts'].join(', ')}'),
            ],
          );
        },
      ),
    );

    // Get the file path
    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/report_$reportId.pdf');
    await file.writeAsBytes(await doc.save());

    // Provide a feedback message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF Downloaded to: ${file.path}')));
  }

Future<void> _sendReport(BuildContext context, String reportId) async {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Send Report via Email'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Recipient Email'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String recipientEmail = emailController.text;
                String subject = 'Report: $reportId';
                String body = 'Please find the attached report: $reportId';

                try {
                  // Create the URL for mailto (using url_launcher)
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: recipientEmail,
                    query: Uri.encodeComponent('Subject=$subject&Body=$body'),
                  );

                  // Check if we can launch the URL
                  if (await canLaunch(emailUri.toString())) {
                    await launch(emailUri.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email Client Opened!')));
                  } else {
                    throw 'Could not launch email client. Please ensure you have an email client installed.';
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send email: $e')));
                }

                Navigator.of(context).pop();
              }
            },
            child: Text('Send'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}



  // Helper function to get the file path of the PDF
  Future<String> _getFilePath(String reportId) async {
    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/report_$reportId.pdf');
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Reports'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('reports').orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reports available.'));
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var report = reports[index];
              String reportId = report.id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Report ${index + 1}'),
                  subtitle: Text('Created on: ${report['created_at'].toDate().toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.download, color: Colors.blue),
                        onPressed: () => _downloadReport(context, reportId),
                      ),
                      IconButton(
                        icon: Icon(Icons.email, color: Colors.green),
                        onPressed: () => _sendReport(context, reportId),
                      ),
                    ],
                  ),
                  onTap: () {
                    // View the detailed report in a new page (optional)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailsPage(reportId: reportId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final String reportId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReportDetailsPage({required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('reports').doc(reportId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No report found.'));
          }

          var report = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ship Arrivals: ${report['total_ship_arrivals']}'),
                Text('Ship Departures: ${report['total_ship_departures']}'),
                Text('Tickets Booked: ${report['number_of_tickets_booked']}'),
                Text('Total Revenue: \$${report['total_revenue']}'),
                Text('Operational Alerts: ${report['operational_alerts'].join(', ')}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add additional actions, such as emailing the report or downloading
                  },
                  child: Text('Take Action'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
