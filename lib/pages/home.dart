import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/create_account.dart';
import 'package:graygreen/pages/entercountry.dart';
import 'package:provider/provider.dart';

import '../current_user_model.dart';
import 'activity_feed.dart';
import 'profile.dart';
import 'search.dart';
import 'timeline.dart';
import 'upload.dart';
import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
final StorageReference storageReference = FirebaseStorage.instance.ref().child("Posts_Pictures");
final postsRef = Firestore.instance.collection('posts');
final DateTime timestamp = DateTime.now();
AppUser currentUser;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in $err');
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error_signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInfirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInfirestore() async {
    //1)check if user exitsts in users collection in database(according to thier id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.document(user.id).get();

   
    //2) if the user doesnt't exitsts, take them to create account page
    if (!doc.exists) {
      final username = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateAccount())) ;

      final country = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Entercountry())) ;
      
      //3) get username from create account,use it to make new user document in user collection
     await  usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "disPlayName": user.displayName,
        "bio": "",
        "country": country ,
        "timeStamp": timestamp,
      });


    }

    
    AppUser currentUser = AppUser.fromDocument(doc);
     context.read<CurrentUser>().user = currentUser;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() async{
    await googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //onTap to cahnge the page
  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    
    return Scaffold(
      body: PageView(
        children: <Widget>[
           Timeline(),
          // RaisedButton(
          //   child: Text('logout'),
          //   onPressed: logout,
          // ),
          ActivityFeed(),
          Upload(gcurrentUser: currentUser,),
          Search(),
          Profile( profileid: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          //active color when we an certain page
          activeColor: Theme.of(context).primaryColor,
          // include the items(childern for page view)
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
            ),
          ]),
    );

    /// return RaisedButton (
    /// child: Text('Logout'),
    //onPressed:logout ,
    //);
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        )),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'GrayGreen',
              style: TextStyle(
                  fontFamily: "Signatra", fontSize: 90.0, color: Colors.white),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
