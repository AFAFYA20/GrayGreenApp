import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/custom_image.dart';
import 'package:graygreen/widgets/progress.dart';
import 'package:provider/provider.dart';

import '../current_user_model.dart';

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
  final dynamic likes;

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
    this.likes,
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
      likes: doc['likes'],
    );
  }

  int getlikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
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
        likes: this.likes,
        likeCount: getlikeCount(this.likes),
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
  int likeCount;
  Map likes;
  bool isLiked;
  bool showheart=false;
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
    this.likes,
    this.likeCount,
  });

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

  builPostImage() {
    return GestureDetector(
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(mediaUrl),
        ],
      ),
    );
  }

   buildPostFooter(){
     return Column(
       children: <Widget> [
         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: <Widget> [
             Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
             GestureDetector(
               onTap: () => print('liking post'),
               child: Icon(
                  Icons.add ,
               // isLiked? Icons.add : Icons.check,
                 size: 28.0,
                 color: Colors.green,
               ),
             ),
             Padding(padding: EdgeInsets.only(right: 20.0)),
             GestureDetector(
               onTap: () => print('showing comments'),
               child: Icon(
                 Icons.chat,
                 size: 28.0,
                 color: Colors.blue[900],
               )
             )
           ],
         ),

         Row(
           children: <Widget>[
             Container(
               margin: EdgeInsets.only(left: 20.0),
               child: Text(
                 "$likeCount likes",
                 style: TextStyle(color: Colors.black,
                 fontWeight: FontWeight.bold,
                 ),
               ),
             )
           ],
         ),
         Row(
           crossAxisAlignment:  CrossAxisAlignment.start,
           children: <Widget>[
            Container(
              margin: EdgeInsets.only(left:20.0),
              child: Text("$username", style: TextStyle( fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Text(description)
            ),

           ],
         ),


       ],
     );
   }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        builPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
