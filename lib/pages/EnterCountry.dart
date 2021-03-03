import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graygreen/widgets/header.dart';

class Entercountry extends StatefulWidget {
  @override
  _EntercountryState createState() => _EntercountryState();
}

class _EntercountryState extends State<Entercountry> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String username;
  String country;
  final _country = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _country.dispose();
    super.dispose();
  }
  _printLatestValue() {
  print("Second text field: ${_country.text}");
}
    void initState() {
    super.initState();

    // Start listening to changes.
    _country.addListener(_printLatestValue);
  }   
 


  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcom $username !"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        //Navigator.pop(context, username);
        Navigator.pop(context, country);
      });
    }
  }


  Widget _bulidUserName() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'User Name'),
        maxLength: 10,
        validator: (String val) {
          if (val.isEmpty) {
            return 'User Name is Required';
          }
        },
        onSaved: (val) => username = val);
  }

  Widget _bulidCountry() {
    return TextFormField(
        controller: _country,
        decoration: InputDecoration(labelText: 'Country'),
        maxLength: 10,
        validator: (String val) {
          if (val.isEmpty) {
            return 'User Name is Required';
          }
        },
        onChanged: (text) {
          print("First text field: $text");
        },
        onSaved: (val) => country = val);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Create aacount')),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             // _bulidUserName(),
              _bulidCountry(),
              SizedBox(height: 0),
              GestureDetector(
                onTap: submit,
                child: Container(
                  height: 50.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // RaisedButton(
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(color: Colors.green, fontSize: 16),
                //   ),
                //   onPressed: () {
                //     if (!_formKey.currentState.validate()) {
                //       return;
                //     }
                //     _formKey.currentState.save();
                //   },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
