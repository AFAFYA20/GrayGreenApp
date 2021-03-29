import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/custom_image.dart';
import 'package:graygreen/widgets/progress.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String phonenumber;
  final String daym;
  final String stime;
  final String etime;
  final String mediaUrl;
  final dynamic enroll;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.phonenumber,
    this.daym,
    this.stime,
    this.etime,
    this.mediaUrl,
    this.enroll,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      phonenumber: doc['phonenumber'],
      daym: doc['daym'],
      stime: doc['stime'],
      etime: doc['etime'],
      mediaUrl: doc['mediaUrl'],
      enroll: doc['enroll'],
    );
  }

  int getEnrollCount(enroll) {
    if (enroll == null) {
      return 0;
    }
    int count = 0;
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
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        phonenumber: this.phonenumber,
        daym: this.daym,
        stime: this.stime,
        etime: this.etime,
        mediaUrl: this.mediaUrl,
        enroll: this.enroll,
        EnrollCount: getEnrollCount(this.enroll),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String phonenumber;
  final String daym;
  final String stime;
  final String etime;
  final String mediaUrl;
  int EnrollCount;
  Map enroll;
  bool isLiked;
  bool showheart = false;
  // final String currentOnlineUser= currentUser.id ;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.phonenumber,
    this.daym,
    this.stime,
    this.etime,
    this.mediaUrl,
    this.enroll,
    this.EnrollCount,
  });
  // String Showlocation = location;
  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) {
          return circularProgress();
        }

        AppUser user = AppUser.fromDocument(datasnapshot.data);
        //  bool isPostOwner= currentOnlineUser == ownerId;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
              onTap: () => print('showing profile'),
              child: Text(user.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))),
          subtitle: Text(location),
          trailing: IconButton(
            onPressed: () => print('deleting post'),
            icon: Icon(Icons.more_vert),
          ),
        );
      },
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
              onTap: () => print(' Enroll post'),
              child: Icon(
                Icons.check_box_outline_blank,
                // isLiked? Icons.add : Icons.check,
                size: 28.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Volunteer Now $EnrollCount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, phonenumber),
          _buildButtonColumn(
            color,
            Icons.near_me,
            "location $location",
          ),
          _buildButtonColumn(color, Icons.calendar_today, daym),
          _buildButtonColumn(color, Icons.timelapse, 'From ' + stime),
          _buildButtonColumn(color, Icons.timelapse, 'To ' + etime),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        Image.network(mediaUrl, width: 400, height: 240, fit: BoxFit.cover),
        buildPostFooter(),
        buttonSection,
        textSection,
      ],
    );
  }
}
