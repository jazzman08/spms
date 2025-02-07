import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spms/pages/admin/Report/ReportPage.dart';

class InputReportPage extends StatefulWidget {
  @override
  _InputReportPageState createState() => _InputReportPageState();
}

class _InputReportPageState extends State<InputReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shipArrivalsController = TextEditingController();
  final TextEditingController _shipDeparturesController = TextEditingController();
  final TextEditingController _ticketsBookedController = TextEditingController();
  final TextEditingController _totalRevenueController = TextEditingController();
  final TextEditingController _operationalAlertsController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add report data to Firestore
  Future<void> _addReport() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create the report document in Firestore
        await _firestore.collection('reports').add({
          'total_ship_arrivals': int.parse(_shipArrivalsController.text),
          'total_ship_departures': int.parse(_shipDeparturesController.text),
          'number_of_tickets_booked': int.parse(_ticketsBookedController.text),
          'total_revenue': double.parse(_totalRevenueController.text),
          'operational_alerts': _operationalAlertsController.text.split(','), // Store alerts as a list
          'created_at': FieldValue.serverTimestamp(),
        });

        // Clear the form
        _shipArrivalsController.clear();
        _shipDeparturesController.clear();
        _ticketsBookedController.clear();
        _totalRevenueController.clear();
        _operationalAlertsController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Function to navigate to the report view page
  void _viewReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportPage()), // Navigating to the existing ReportPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Daily Report'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(  // Fixes bottom overflow by enabling scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _shipArrivalsController,
                  decoration: InputDecoration(labelText: 'Total Ship Arrivals'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of ship arrivals';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _shipDeparturesController,
                  decoration: InputDecoration(labelText: 'Total Ship Departures'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of ship departures';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ticketsBookedController,
                  decoration: InputDecoration(labelText: 'Number of Tickets Booked'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of tickets booked';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalRevenueController,
                  decoration: InputDecoration(labelText: 'Total Revenue'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the total revenue';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _operationalAlertsController,
                  decoration: InputDecoration(labelText: 'Operational Alerts (comma separated)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter any operational alerts';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addReport,
                  child: Text('Submit Report'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _viewReport,  // Navigate to the Report Page
                  child: Text('View Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
