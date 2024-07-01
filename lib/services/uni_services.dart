import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:uni_links2/uni_links.dart';

class UniService {
  static String _code = '';
  static String get code => _code;
  static bool get hasCode => _code.isEmpty;

  static void reset() => _code = '';

  static Future<void> init() async {
    try {
      final Uri? uri = await getInitialUri();
      await Future.delayed(Duration.zero); // Ensure the app is fully loaded
      uniHandler(uri);
    } on PlatformException catch (e) {
      log('Failed to receive the code');
    } on FormatException {
      log('Wrong format code received');
    }
    uriLinkStream.listen((Uri? uri) {
      uniHandler(uri);
    }, onError: (e) {
      log('onUriLink error==>${e.toString()}');
    });
  }

  static void uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;
    Map<String, String> param = uri.queryParameters;
    String receiveCode = param['code'] ?? '';
    if (receiveCode.isNotEmpty) {
      final dataNews = {
        "newsTitle": 'City News',
        "newsURL": receiveCode,
        "data": '',
      };
      Get.to(() => WebviewScreen(), arguments: dataNews);
    } else {
      Get.to(() => HomeScreen());
    }
  }
}
