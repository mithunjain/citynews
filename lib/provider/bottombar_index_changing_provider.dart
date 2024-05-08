import 'package:flutter/material.dart';

class BottomBarIconIndexManagementProvider extends ChangeNotifier {
  int _bottomSelectedIconIndex = 0;

  setNewBottomIconIndex(newIndex) {
    _bottomSelectedIconIndex = newIndex;
    notifyListeners();
  }

  getCurrentBottomIconIndex() => _bottomSelectedIconIndex;
}
