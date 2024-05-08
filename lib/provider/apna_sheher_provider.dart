import 'package:flutter/material.dart';

class ApnaSheherIndexProvider extends ChangeNotifier {
  int pageIndex = 0;
  int currOperatingPageIndex = -1;
  PageController pagecontroller = PageController(initialPage: 0);

  void onlychangeIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void changePage(int index) {
    pageIndex = index;
    print("Changed to " + pageIndex.toString());
    pagecontroller.animateToPage(pageIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    pageIndex = index;
    notifyListeners();
  }

  void changeCurrentOperationPageIndex(int index){
    this.currOperatingPageIndex = index;
    print("Current Page Operating Index Changed to " + pageIndex.toString());
    notifyListeners();
  }
}
