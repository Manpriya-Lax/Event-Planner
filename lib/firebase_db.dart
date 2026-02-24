import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseDB {
 static FirebaseFirestore instance = FirebaseFirestore.instance;
 
static geteventsCollection() async {
 var eventsCollection = await instance.collection("event planner").get();
 return eventsCollection.docs;
}
}