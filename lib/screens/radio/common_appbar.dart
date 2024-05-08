import 'package:flutter/material.dart';
import 'package:news/data/size_collection.dart';
import 'package:news/screens/radio/sub_screen_scrollManagement.dart';

import 'package:provider/provider.dart';

autoHideAppBarOnScroll(context, Widget appBar) {
  final bool _isMainAppBarVisible =
      Provider.of<SubScrollManagement>(context).isMainAppBarVisible();

  return PreferredSize(
      child: appBar,
      preferredSize: Size(MediaQuery.of(context).size.width,
          _isMainAppBarVisible ? SizeCollection.kAppBarHeight : 0));
}
