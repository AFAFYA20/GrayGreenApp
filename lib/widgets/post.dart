import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/current_user_model.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/custom_image.dart';
import 'package:graygreen/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String owner;
  final String username;
  final String locaion;
  final String description;
  final String phonenumber;
  final String dayToMeet;
  final String meetStart;
  final String meetEnd;
  final String mediaUrl;
  final dynamic enroll;

  Post({
    this.postId,
    this.owner,
    this.username,
    this.locaion,
    this.description,
    this.phonenumber,
    this.dayToMeet,
    this.meetStart,
    this.meetEnd,
    this.mediaUrl,
    this.enroll,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      owner: doc['owner '],
      username: doc['username'],
      locaion: doc['locaion'],
      description: doc['description'],
      phonenumber: doc['phonenumber'],
      dayToMeet: doc['dayToMeet'],
      meetEnd: doc['meetEnd'],
      mediaUrl: doc['mediaUrl'],
      enroll: doc['enroll'],
    );
  }

  int getEnrollCount(enroll) {
    // if no enroll, return 0
    if (enroll == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a enroll
    enroll.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        owner: this.owner,
        username: this.username,
        locaion: this.locaion,
        description: this.description,
        phonenumber: this.phonenumber,
        dayToMeet: this.dayToMeet,
        meetStart: this.meetStart,
        meetEnd: this.meetEnd,
        mediaUrl: this.mediaUrl,
        enroll: this.enroll,
        enrollCount: getEnrollCount(this.enroll),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String owner;
  final String username;
  final String locaion;
  final String description;
  final String phonenumber;
  final String dayToMeet;
  final String meetStart;
  final String meetEnd;
  final String mediaUrl;
  int enrollCount;
  Map enroll;
  bool isEnroll;
  bool showButton = false;
  final String currentOnEnrollUserId = currentUser?.id;

  _PostState({
    this.postId,
    this.owner,
    this.username,
    this.locaion,
    this.description,
    this.phonenumber,
    this.dayToMeet,
    this.meetStart,
    this.meetEnd,
    this.mediaUrl,
    this.enroll,
    this.enrollCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(owner),
          builPostImage(),
          buildPostFooter(),
        ],
      ),
    );
  }

  buildPostHeader(owner) {
    return FutureBuilder(
      future: usersRef.document(owner).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        AppUser user = AppUser.fromDocument(dataSnapshot.data);
        //Post post = Post.fromDocument(dataSnapshot.data);
        bool isPosterOwner = currentOnEnrollUserId == owner;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
             CachedNetworkImageProvider(
                user.photoUrl
                ),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print("Show Profile"),
            child: Text(
              //user.username
              user.username,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(
            locaion,
            style: TextStyle(color: Colors.black),
          ),
          
          trailing: isPosterOwner
              ? IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.green),
                  onPressed: () => print("deleted"),
                )
              : Text(""),
        );
      },
    );
  }

  builPostImage() {
    return GestureDetector(
      onDoubleTap: () => print('enroll post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print('Enroall button'),
              child: Icon(
                Icons.brightness_1_outlined,
                color: Colors.green[900],
                // isEnroll? Icons.brightness_1_outlined: Icons.brightness_1,
                // size: 28.0,
                // color: Colors.green[900],
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => print('show comments'),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                //username
                "$enrollCount enroll",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(color: Colors.black),
              ),
            ),
             Expanded(
              child: Text(
                phonenumber,
                style: TextStyle(color: Colors.black),
              ),
            ),
             Expanded(
              child: Text(
                dayToMeet,
                style: TextStyle(color: Colors.black),
              ),
            ),
             Expanded(
              child: Text(
                meetStart,
                style: TextStyle(color: Colors.black),
              ),
            ),
             Expanded(
              child: Text(
                meetEnd,
                style: TextStyle(color: Colors.black),
              ),
            ),
             Expanded(
              child: Text(
                locaion,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
