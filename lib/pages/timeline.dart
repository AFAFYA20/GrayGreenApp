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
    //getUserById();
    //createUser();
    //updateUser();
    deletUeser();
    super.initState();
  }

  createUser() {
    usersRef
        .document("asdfasfd")
        .setData({"username": "sara", "postcount": 0, "isAdmin": "false"});
  }

  updateUser() async {
    final doc = await usersRef.document("3b9xAlnUDz9cXSzOCDKj").get();
    //To make sure it's exists
    if (doc.exists) {
      doc.reference
          .updateData({"username": "noor", "postcount": 0, "isAdmin": "false"});
    }
  }

  deletUeser() async {
    final DocumentSnapshot doc =
        await usersRef.document("3b9xAlnUDz9cXSzOCDKj").get();
    if (doc.exists) {
      doc.reference.delete();
    }
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
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents
              .map((doc) => Text(doc['username']))
              .toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
