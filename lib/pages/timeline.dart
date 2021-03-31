import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/edit_profile.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/header.dart';
import 'package:graygreen/widgets/post.dart';
import 'package:graygreen/widgets/post_tile.dart';
import 'package:graygreen/widgets/progress.dart';
import 'package:provider/provider.dart';
import '../current_user_model.dart';


//create refrence point to collection
//final usersRef = Firestore.instance.collection('Users');

class Timeline extends StatefulWidget {
   
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  
   bool isFollowing = false;
  final String currentUserId = currentUser?.id;
  bool Loading = false;

  int postCount = 0;
  List<Post> postsList = [];
  
  void initState() {
    getProfilePosts(currentUser);
  }
  buildProfilePosts(currentUser) {
    currentUser = context.read<CurrentUser>().user;
    if (Loading) {
      return circularProgress();
    } else if (postsList?.isEmpty ?? '') {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              //child: Icon(Icons.photo_library, color: Colors.grey, size: 200.0),
            ),
            Padding(
              padding: EdgeInsets.all(150),
              child: Text(
                "No Posts",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    
    } 
    return ListView(
        
        children: postsList,
      );
    
  }

  getProfilePosts(currentUser) async {
    currentUser = context.read<CurrentUser>().user;
  
    setState(() {
      Loading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .document(currentUser.id)
        .collection("usersPosts")
        .orderBy('timestamp', descending: true)
        .getDocuments();

    setState(() {
      Loading = false;
      postCount = snapshot.documents.length;
      postsList =
          snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  @override
  //fetching data from firestore
  Widget build(context) {
   final currentUser = context.watch<CurrentUser>().user;
  return Scaffold(
     appBar: header(context, titleText: "TimeLine"),
     body: buildProfilePosts(currentUser)
        
     
  );
  }
}

  
