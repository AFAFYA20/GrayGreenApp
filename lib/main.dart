import 'package:flutter/material.dart';
import 'package:graygreen/pages/home.dart';
import 'package:provider/provider.dart';

import 'current_user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUser>.value(
      value: CurrentUser(),
      child: MaterialApp(
        title: 'GrayGreen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green[600],
          accentColor: Colors.lightGreen[900],
        ),
        home: Home(),
      ),
    );
  }
}
