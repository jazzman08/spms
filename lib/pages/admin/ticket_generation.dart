import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:spms/service/database.dart';

class TicketGeneration extends StatefulWidget {
  const TicketGeneration({super.key});

  @override
  State<TicketGeneration> createState() => _TicketGenerationState();
}

class _TicketGenerationState extends State<TicketGeneration> {
  TextEditingController ferrynamecontroller = TextEditingController();
  TextEditingController dateoftravelcontroller = TextEditingController();
  TextEditingController ticketpricecontroller = TextEditingController();
  
  String ticketType = "One Way"; // Default value for ticket type
  String classOfTravel = "Economy"; // Default value for class of travel

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dateoftravelcontroller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format as yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ticket",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "GenerationForm",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ferry Name",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: ferrynamecontroller,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Ticket Type",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  value: ticketType,
                  onChanged: (String? newValue) {
                    setState(() {
                      ticketType = newValue!;
                    });
                  },
                  isExpanded: true,
                  items: <String>['One Way', 'Two Way']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Date of Travel",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: dateoftravelcontroller,
                  readOnly: true,
                  decoration: const InputDecoration(
                      hintText: "Select a date", border: InputBorder.none),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Class of Travel",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  value: classOfTravel,
                  onChanged: (String? newValue) {
                    setState(() {
                      classOfTravel = newValue!;
                    });
                  },
                  isExpanded: true,
                  items: <String>['Economy', 'Standard', 'Business']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Ticket Price",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: ticketpricecontroller,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String Id = randomNumeric(10);
                    Map<String, dynamic> ticketInfoMap = {
                      "ferry name": ferrynamecontroller.text,
                      "ticket type": ticketType,
                      "date of travel": dateoftravelcontroller.text,
                      "class of travel": classOfTravel,
                      "Id": Id,
                      "ticket price": ticketpricecontroller.text,
                    };
                    await DatabaseMethods().addTicketDetails(ticketInfoMap, Id).then((value) {
                      Fluttertoast.showToast(
                        msg: "Ticket Details have been uploaded successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
