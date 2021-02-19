import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/widgets/header.dart';
import 'package:graygreen/widgets/progress.dart';

//create refrence point to collection
final usersRef = Firestore.instance.collection('Users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  //fetching data from firestore
  void initState() {
    getUsers();
    //getUserById();

    super.initState();
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.getDocuments();
    //getDocument is function to get data of each collection
    //usersRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        print(doc.data);
        print(doc.documentID);
        print(doc.exists);
      });
   // });
  }
  /* getUserById() async{
   final String id = "3b9xAlnUDz9cXSzOCDKj";
   final DocumentSnapshot doc = await usersRef.document(id).get();
     print(doc.data);
     print(doc.documentID);
     print(doc.exists);  
  
 }
 */

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: linearProgress(),
    );
  }
}
