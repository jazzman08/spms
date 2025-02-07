import 'package:flutter/material.dart';

class AdminResourcesPage extends StatefulWidget {
  @override
  _AdminResourcesPageState createState() => _AdminResourcesPageState();
}

class _AdminResourcesPageState extends State<AdminResourcesPage> {
  // A sample list of resources (this could come from an API or Firebase)
  final List<String> resources = [
    'Report_1.pdf',
    'Ship_Details.xlsx',
    'Operational_Guide.docx',
    'Employee_Manual.pdf',
    'System_Logs.csv'
  ];

  // Function to handle resource deletion (simulated)
  void _deleteResource(String resource) {
    setState(() {
      resources.remove(resource);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$resource deleted successfully')),
    );
  }

  // Function to simulate opening a resource (e.g., download or view)
  void _openResource(String resource) {
    // Add code to view or download the resource
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $resource...')),
    );
  }

  // Function to add a new resource (simulated)
  void _addResource() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Resource'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter resource name'),
            onSubmitted: (value) {
              setState(() {
                resources.add(value);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value added successfully')),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Resources'),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addResource,
              child: Text('Add New Resource'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  String resource = resources[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(resource),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.open_in_new, color: Colors.blue),
                            onPressed: () => _openResource(resource),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteResource(resource),
                          ),
                        ],
                      ),
                    ),
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
