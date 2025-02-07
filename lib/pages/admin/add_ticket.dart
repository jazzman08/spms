import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spms/pages/admin/ticket_generation.dart';
import 'package:spms/service/database.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({super.key});

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
    TextEditingController ferrynamecontroller = TextEditingController();
  TextEditingController tickettypecontroller = TextEditingController();
  TextEditingController dateoftravelcontroller = TextEditingController();
  TextEditingController classoftravelcontroller = TextEditingController();
  TextEditingController ticketpricecontroller = TextEditingController();
  Stream? ticketStream;

getonthload()async{
  ticketStream= await DatabaseMethods().getTicketDetails();
  setState(() {
    
  });
}

@override
void initState() {
  getonthload();
  super.initState();
  
}
  // This function returns a widget that displays the ticket details
  Widget allTicketDetails() {
    return StreamBuilder(
      stream: ticketStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
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
                              "Ferry: " + ds["ferry name"],
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: (){
                              ferrynamecontroller.text=ds["ferry name"];
                              tickettypecontroller.text=ds["ticket type"];
                              dateoftravelcontroller.text=ds["date of travel"];
                              classoftravelcontroller.text=ds["class of travel"];
                              ticketpricecontroller.text=ds["ticket price"];
                              EditTicketDetails(ds["Id"]);
                              },
                              child: const Icon(Icons.edit, color:Colors.orange ,)),
                              const SizedBox(width: 5.0,),
                              GestureDetector(
                                onTap: ()async{
                                await DatabaseMethods().DeleteTicketDetail(ds["Id"]);
                                },
                                child: const Icon(Icons.delete, color: Colors.orange,))
                          ],

                          
                        ),
                        Text(
                          "Type: " + ds["ticket type"],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Date: " + ds["date of travel"],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Class: " + ds["class of travel"],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Price: " + ds["ticket price"],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TicketGeneration()),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tickets",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
          Expanded(child: allTicketDetails()),
            ],
            ),
        ),
      );
  }

  Future EditTicketDetails(String Id)=>showDialog(context: context, builder: (context)=>AlertDialog(
    content: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(children: [
          GestureDetector(
            onTap:(){
              Navigator.pop(context);
            } ,
            child: const Icon(Icons.cancel)),
            const SizedBox(width: 60.0),
            const Text(
              "Edit",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const Text(
              "Details",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),
            ),
        ],),
        const SizedBox(height: 20.0),
          const Text("Ferry Name",style:
          TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: ferrynamecontroller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Ticket type",style:
          TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: tickettypecontroller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Date of Travel",style:
          TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: dateoftravelcontroller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Class of travel",style:
          TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: classoftravelcontroller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Ticket Price",style:
          TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: ticketpricecontroller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 30.0,),
          Center(child: ElevatedButton(onPressed: () async {
            Map<String, dynamic>updateInfo={
              "ferry name":ferrynamecontroller.text,
              "ticket type":tickettypecontroller.text,
              "date of travel":dateoftravelcontroller.text,
              "class of travel":classoftravelcontroller.text,
              "Id":Id,
              "ticket price":ticketpricecontroller.text,
            };
            await DatabaseMethods().UpdateTicketDetail(Id, updateInfo).then((value) {
              Navigator.pop(context);
            });
          }, child: const Text("Update"))),
      ],),
      ),
  ));
}
