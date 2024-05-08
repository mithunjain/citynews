import 'package:flutter/material.dart';

class HomePageIndexProvider extends ChangeNotifier {
  int pageIndex = 0;
  int tabIndex = 0;
  PageController pagecontroller = PageController(initialPage: 0);

  void onlychangeIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void changePage(int index) {
    pageIndex = index;
    print("Changed to " + pageIndex.toString());
    if (pagecontroller.hasClients)
      pagecontroller.animateToPage(pageIndex,
          duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    pageIndex = index;
    notifyListeners();
  }

  changeTabIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
