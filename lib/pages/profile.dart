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



class Profile extends StatefulWidget {
  final String profileid;

  Profile({this.profileid});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  bool Loading = false;
  int postCount = 0;
  List<Post> postsList = [];
  String postOriention = 'grid';

  @override
  void initState() {
    getProfilePosts(currentUser);
  }

  buildProfileButton(currentUser) {
    //If you're vewing your own profile - should show the edit profile button
    bool isProfileOwner = currentUser.id == currentUser.id;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
     //   performFunction: editUserProfile(currentUser),
      );
    }
  }

  Container buildButton({String text, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: TextButton(
        onPressed: performFunction,
        child: Container(
          width: 245.0,
          height: 26.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  // editUserProfile(currentUser) {
  //   currentUser = context.read<CurrentUser>().user;
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => EditProfile( currentUserId :currentUser.id)));
  // }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>().user;
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(currentUser),
          Divider(),
          createListAndGridPostOrientation(),
          Divider(height: 0.0),
          buildProfilePosts(currentUser),
        ],
      ),
    );
  }

  buildProfileHeader(currentUser) {
    currentUser = context.read<CurrentUser>().user;

    return FutureBuilder(
      future: usersRef.document(currentUser.id).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        AppUser user = AppUser.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(currentUser?.photoUrl),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            bulidCountColumn("Posts", 0),
                            bulidCountColumn("followeres", 0),
                            bulidCountColumn("following", 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(currentUser),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  currentUser?.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(top: 4.0),
              //   child: Text(
              //     currentUser?.displayName??'',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(top: 2.0),
              //   child: Text(
              //     currentUser?.bio??'',
              //   ),
              // ),
            ],
          ),
        );
      },
    );
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
              padding: EdgeInsets.only(top: 20.0),
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
    } else if (postOriention == 'grid') {
      List<GridTile> gridTiles = [];
      postsList.forEach((eachPost) {
        gridTiles.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOriention == 'list') {
      return Column(
        children: postsList,
      );
    }
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

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setOrientation('grid'),
          icon: Icon(Icons.grid_on),
          color: postOriention == 'grid'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation('list'),
          icon: Icon(Icons.list),
          color: postOriention == 'list'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOriention = orientation;
    });
  }

  Column bulidCountColumn(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
