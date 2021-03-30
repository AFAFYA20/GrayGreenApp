import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/custom_image.dart';
import 'package:graygreen/widgets/progress.dart';

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
  final dynamic Enroll;

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
    this.Enroll,
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
      Enroll: doc['Enroll'],
    );
  }

  int getEnrollCount(Enroll) {
    if (Enroll == null) {
      return 0;
    }
    int count = 0;
    Enroll.values.forEach((val) {
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
        Enroll: this.Enroll,
        EnrollCount: getEnrollCount(this.Enroll),
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
  Map Enroll;
  bool isEnroll;
  bool showheart = false;
  final String currentUserId = currentUser?.id;
  DocumentReference EnrollRef;

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
    this.Enroll,
    this.EnrollCount,
  });

  handelEnroll() {
    bool _isEnroll = Enroll[currentUserId] == true;
    if (_isEnroll) {
      postsRef
          .document(ownerId)
          .collection('usersPosts')
          .document(postId)
          .updateData({'Enroll.$currentUserId': false});
      setState(() {
        EnrollCount -= 1;
        isEnroll = false;
        Enroll[currentUserId] = false;
      });
    } else if (!_isEnroll) {
      postsRef
          .document(ownerId)
          .collection('usersPosts')
          .document(postId)
          .updateData({'Enroll.$currentUserId': true});
      setState(() {
        EnrollCount += 1;
        isEnroll = true;
        Enroll[currentUserId] = true;
      });
    }
  }

  buildEnroll() {
    return GestureDetector(
      onDoubleTap: () => print('Enroll'),
      // child: Stack(
      //   alignment: Alignment.center,
      //   children: <Widget>[Image.network(mediaUrl)],
      // ),
    );
  }

  buildPostHeader() {
    buildEnroll();
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
                    fontWeight: FontWeight.w300,
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
              onTap: handelEnroll,
              child: Icon(
                isEnroll ? Icons.check_box : Icons.add,
                size: 28.0,
                color: Colors.green,
              ),
              // onPressed: () {
              //   //postsRef;
              // },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Clik here to volunteer with $EnrollCount",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
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
              fontWeight: FontWeight.normal,
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
          _buildButtonColumn(color, Icons.calendar_today, daym),
          _buildButtonColumn(color, Icons.call, phonenumber),
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
    isEnroll = (Enroll[currentUserId] == true);
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
