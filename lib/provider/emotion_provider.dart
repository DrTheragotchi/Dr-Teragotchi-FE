import 'package:flutter/material.dart';

class EmotionProvider with ChangeNotifier {
  String _emotion = '';

  String get emotion => _emotion;

  void setEmotion(String newEmotion) {
    _emotion = newEmotion;
    notifyListeners();
  }

  String getEmotion() {
    return _emotion;
  }
}
