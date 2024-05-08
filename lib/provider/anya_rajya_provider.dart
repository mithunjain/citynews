import 'package:flutter/material.dart';

class AnyaRajyaProvider extends ChangeNotifier {
  List ragyaName = [];
  int pageIndex = 0;
  PageController pagecontroller = PageController(initialPage: 0);

  void storeRajyaName(List ragyNameData) {
    ragyaName = ragyNameData;
    notifyListeners();
  }
}
