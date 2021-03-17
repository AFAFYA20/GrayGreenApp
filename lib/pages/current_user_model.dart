import 'package:flutter/cupertino.dart';
import 'package:graygreen/models/user.dart';

class CurrentUser extends ChangeNotifier {
  AppUser _user;
  set user(AppUser user) {
    _user = user;
    notifyListeners();
  }

  get user => _user;

  clear() {
    _user = null;
    notifyListeners();
  }
}
