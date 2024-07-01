import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

updateAppFunctionality() {
  try {
    launch("market://details?id=" + 'com.citynews.india');
  } on PlatformException catch (_) {
    launch("https://play.google.com/store/apps/details?id=" +
        'com.citynews.india');
  } finally {
    launch("https://play.google.com/store/apps/details?id=" +
        'com.citynews.india');
  }
}

ratingAppFunctionality() {
  try {
    launch("market://details?id=" + 'com.citynews.india');
  } on PlatformException catch (_) {
    launch("https://play.google.com/store/apps/details?id=" +
        'com.citynews.india');
  } finally {
    launch("https://play.google.com/store/apps/details?id=" +
        'com.citynews.india');
  }
  // _launchURL(
  //     'https://play.google.com/store/apps/details?id=com.citynews.india');
}

void showCustomSnackBar(
    {required BuildContext context,
    required Color color,
    required String text}) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 1500),
    backgroundColor: color,
    content: Text(text),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
