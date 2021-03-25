import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graygreen/models/user.dart';
import 'package:graygreen/pages/home.dart';
import 'package:graygreen/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD ;
import '../current_user_model.dart';

class Upload extends StatefulWidget {
  final AppUser gcurrentUser;
  Upload({this.gcurrentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> with AutomaticKeepAliveClientMixin<Upload> {
  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  final locationConttroller = TextEditingController() ;
  final descConttroller = TextEditingController() ;
  final phonecConttroller = TextEditingController() ;
  final dayConttroller = TextEditingController() ;
  final meetsConttroller = TextEditingController() ;
  final meeteConttroller = TextEditingController() ;
  
  

  handelTakePhoto() async {
    Navigator.pop(context);
    File imgeFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = imgeFile;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File imgeFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = imgeFile;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Publish a case"),
            children: <Widget>[
              SimpleDialogOption(
               child: Text("Photo With Camera"),
                onPressed:(){ handelTakePhoto();},
              ),
             SimpleDialogOption(
                child: Text("Image from Gallery"),
               onPressed: (){ handleChooseFromGallery();},
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }


  Container buildSplashScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate, color: Colors.grey, size:200.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Uplaod Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.green,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearPostInfo() {
    locationConttroller.clear();
    descConttroller.clear();
    phonecConttroller.clear();
    dayConttroller.clear();
    meetsConttroller.clear();
    meeteConttroller.clear();

    setState(() {
      file = null;
    });
  }
  compressingPhoto() async{
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path ;
    ImD.Image  mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile= File ('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality:90));
    setState(() {
      file = compressedImageFile;
    });
  }



  controlUploadAndSave(currentUser)async{
    setState(() {
      uploading = true;
    });
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFireStore( gcurrentUser: currentUser, url: downloadUrl, location: locationConttroller.text, description: descConttroller.text, contactphone: phonecConttroller.text, dayToMeet: dayConttroller.text, meetStart: meetsConttroller.text, meetEnd: meeteConttroller.text );
    locationConttroller.clear();
    descConttroller.clear();
    phonecConttroller.clear();
    dayConttroller.clear();
    meetsConttroller.clear();
    meeteConttroller.clear();

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();

    });
  }


  savePostInfoToFireStore({String url, String location, String description, String contactphone, String dayToMeet, String meetStart, String meetEnd, AppUser gcurrentUser } ){
    postsRef.document(gcurrentUser.id).collection("usersPosts").document(postId).setData({
      "postId": postId,
      "ownerId": gcurrentUser.id,
      "timestamp": timestamp,
      "Likes": {},
      "username": gcurrentUser.username,
      "description": description,
      "locaion": location,
      "url": url,
      "contactphone":contactphone,
      "dayToMeet": dayToMeet,
      "meetStart":meetStart,
      "meetEnd": meetEnd,

    });

  }
  Future<String> uploadPhoto(mImageFile) async{
    StorageUploadTask mstorageUploadTask = storageReference.child("post_$postId.jpg ").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot= await mstorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl ;
    
  }

  Scaffold buildUploadForm(currentUser) {
    currentUser = context.read<CurrentUser>().user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearPostInfo ),
        title: Text(
          "Case Information",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => controlUploadAndSave(currentUser) ,
            child: Text(
              "share",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
      body: ListView(
        
        children: <Widget>[
          uploading ? linearProgress() : Text("ttt"),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
            backgroundImage:
              CachedNetworkImageProvider(currentUser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: descConttroller,
                decoration: InputDecoration(
                  hintText: "write a short description of the case",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.call,
              color: Colors.green,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: phonecConttroller,
                decoration: InputDecoration(
                  hintText: "+966 502498417",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: dayConttroller,
                decoration: InputDecoration(
                  hintText: "which day to meet up?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
           Divider(),
          ListTile(
            leading: Icon(
              Icons.timelapse,
              color: Colors.green,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: meetsConttroller,
                decoration: InputDecoration(
                  hintText: "meeting start at 8:00am",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
           ListTile(
            leading: Icon(
              Icons.timelapse,
              color: Colors.white,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: meeteConttroller,
                decoration: InputDecoration(
                  hintText: "meeting end at 10:30am",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
           Divider(),
            ListTile(
            
            leading: Icon(
              Icons.pin_drop,
              color: Colors.green,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationConttroller,
                decoration: InputDecoration(
                  hintText: "Your city? ",
                  border: InputBorder.none,
                
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                "Use Current Location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.green,
              onPressed:(){ getUserLocation();},
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition
    ( desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress = "${placemark.locality} ,${placemark.country}";
    locationConttroller.text = formattedAddress;
    

  }
  bool get wantKeepAlive => true ;
  @override
  Widget build(BuildContext context) {
    final currentUser =  context.watch<CurrentUser>().user;

    return file == null ? buildSplashScreen() : buildUploadForm(currentUser);
  }
}
