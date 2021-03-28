import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController SearchController = TextEditingController();
  Future<QuerySnapshot> searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("country", isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResultFuture = users;
    });
  }

  clearSearch() {
    SearchController.clear();
  }

  AppBar bulidSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        //contect controller with the text form feild
        controller: SearchController,
        decoration: InputDecoration(
          hintText: "Search for publishers in your city..",
          //gray backround
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container bulidNoContent() {
    return Container(
      child: Center(
        //ListView resize the kepord
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.people,color: Colors.green, size: 150.0),
          ],
        ),
      ),
    );
  }

  bulidSearchResults() {
    return FutureBuilder(
        future: searchResultFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<UserResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            AppUser user = AppUser.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return ListView(
            children: searchResults,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bulidSearchField(),
      body:
          searchResultFuture == null ? bulidNoContent() : bulidSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final AppUser user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Column(
          children: <Widget>[
            //when clik on gaiven result we want to taken to profile page
            GestureDetector(
              onTap: () => print('tapped'),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                // title: Text(
                //   user.displayName,
                //   style: TextStyle(color: Colors.white
                //       //color: Colors.white, fontWeight: FontWeight.bold
                //       ),
                //),
                title: Text(
                  user.username,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            //Divider to divie the results from next one if we have mulit results
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
          ],
        ));
  }
}
