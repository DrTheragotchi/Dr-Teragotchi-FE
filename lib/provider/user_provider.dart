import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  int _userAge = 0;

  String get userName => _userName;
  int get userAge => _userAge;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUserAge(int age) {
    _userAge = age;
    notifyListeners();
  }

  void resetUser() {
    _userName = '';
    _userAge = 0;
    notifyListeners();
  }
}
