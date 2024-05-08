import 'package:flutter/material.dart';

Widget commonHorizontalScrolling(
    {required BuildContext context,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount}) {
  return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: itemBuilder);
}

Widget commonHorizontalPagination(
    {required PageController pageController,
    required void Function(int)? onPageChanged,
    required int pageViewItemCount,
    required Widget Function(BuildContext, int) pageViewItemBuilder}) {
  return PageView.builder(
      controller: pageController,
      // scrollBehavior: const ScrollBehavior(
      //     androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
      onPageChanged: onPageChanged,
      itemCount: pageViewItemCount,
      itemBuilder: pageViewItemBuilder);
}
