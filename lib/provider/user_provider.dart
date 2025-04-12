import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  String uuid = '';
  String animalType = '';
  String animalLevel = '';
  String emotion = '';
  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUuid(String id) {
    uuid = id;
    notifyListeners();
  }

  void setAnimalType(String type) {
    animalType = type;
    notifyListeners();
  }

  void setAnimalLevel(String level) {
    animalLevel = level;
    notifyListeners();
  }

  void setEmotion(String newEmotion) {
    emotion = newEmotion;
    notifyListeners();
  }
}
