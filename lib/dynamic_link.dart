// ignore_for_file: unused_local_variable
import 'dart:developer';

import 'package:get/get.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:firebase_core/firebase_core.dart';

Future<String> generateUrl(data) async {
  //print(data);
  final tempData = data as Map;

  if(Firebase.apps.length == 0)
    await Firebase.initializeApp();


  //await Firebase.initializeApp();

  List<String> splittedUrl = data['newsURL'].split('/');
  print(splittedUrl);

  print("dddddddddddddddddddddddddddddddddddd");
  print(tempData['data']['main_image']);
  //print(data['data']['main_image']);
  // Uri image = Uri.parse(data["data"]["main_image"].toString());
  // print(Uri.parse(data["data"]["main_image"].toString()));
  print("helllo" + tempData.toString());
  if (!readNews.contains(data['newsTitle'])) readNews.add(data['newsTitle']);

  final parameters = DynamicLinkParameters(
    uriPrefix: "https://ingnnewsbank.page.link",
    navigationInfoParameters:
        NavigationInfoParameters(forcedRedirectEnabled: false),
    link: Uri.parse(
        "https://ingnnewsbank.page.link?link=${data['newsURL']}&newsTitle=${data['newsTitle']}"),

    //  link: Uri.parse("https://www.google.com/news?data=${jsonEncode(data)}"),
    androidParameters: AndroidParameters(packageName: "com.newsbank.app"),
  );

  final ShortDynamicLink shortDynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  final Uri shortUrl = shortDynamicLink.shortUrl;

  print("Short url is: ${shortUrl}");

  return "https://ingnnewsbank.page.link" + shortUrl.path;
}

Future<void> startDynamicLink() async {
  print("INSIDEEEEEEE");
  await Future.delayed(Duration(seconds: 3));
  var data = await FirebaseDynamicLinks.instance.getInitialLink();
  var deepLink = data?.link;

  final url = deepLink?.queryParameters['link'];
  final newsTitle = deepLink?.queryParameters['newsTitle'];
  final query = {
    'newsURL': url,
    'data': {"imported_news_url": url},
    "newsTitle": newsTitle
  };
  print(query);

  // Get.to(WebviewScreen(), arguments: query);
}

Future<void> initDynamicLink() async {
  print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSMukulbhhhhhhhhh");
  FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
    var deepLink = linkData.link;
    log('deeplink path===>${deepLink.path}');
    final url = deepLink.queryParameters['link'];
    if (url != null) {
      final newsTitle = deepLink.queryParameters['newsTitle'];
      final query = {
        'newsURL': url,
        'data': {"imported_news_url": url},
        "newsTitle": newsTitle
      };
      Get.to(WebviewScreen(), arguments: query);
      print("Done");
    }

    try {
      //  print(jsonDecode(data.toString()));
    } catch (er) {
      print(er);
    }

    debugPrint('Dynamic Links onLink $deepLink');
  }, onError: (e) async {
    debugPrint('Dynamic Links error $e');
  });
}
