import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addTicketDetails(Map<String, dynamic>ticketInfoMap, String id) async {
    return await FirebaseFirestore.instance
    .collection("ticket")
    .doc(id)
    .set(ticketInfoMap);
  }

  Future<Stream<QuerySnapshot>> getTicketDetails() async {
    return FirebaseFirestore.instance.collection("ticket").snapshots();
  }


  Future UpdateTicketDetail(String id, Map<String,dynamic> updateInfo)async{
    return await FirebaseFirestore.instance.collection("ticket").doc(id).update(updateInfo);
  }

  Future DeleteTicketDetail(String id)async{
    return await FirebaseFirestore.instance.collection("ticket").doc(id).delete();
  }
}