import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/custome_web_view_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewScreen extends StatefulWidget {
  // String newsTitle;
  // String newsURL;
  // dynamic data;
  // WebviewScreen(
  //     {required this.newsTitle, required this.newsURL, required this.data});
  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final controller = ScrollController();

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdsReady = false;

  // bool _interstitialAdsShown = false;

  @override
  void dispose() {
    if (_isInterstitialAdsReady) this._interstitialAd.dispose();
    super.dispose();
  }

  void navigate() async {
    await startDynamicLink();
  }

  @override
  void initState() {
    super.initState();
    // navigate();
    // print("on news click");
    // InterstitialAd.load(
    //     adUnitId: AdHelper.interstitialAdUnitId,
    //     request: AdRequest(),
    //     adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) async {
    //       print("At ads Initialize at webview");
    //       if (mounted) {
    //         setState(() {
    //           this._isInterstitialAdsReady = true;
    //           this._interstitialAd = ad;
    //         });
    //       }
    //     }, onAdFailedToLoad: (LoadAdError error) {
    //       print("failed to Load Interstitial Ad ${error.message}");
    //     }));

    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  late bool showCircle = false;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    final args = Get.arguments as Map<String, dynamic>;

    log('in webview');
    return Scaffold(
      // if (!_interstitialAdsShown) {
      //   await _interstitialAd.show();
      //   if (mounted) {
      //     setState(() {
      //       this._interstitialAdsShown = true;
      //     });
      //   }
      //   return true;
      // }

      // print("Interstitial Ads ready status: ${this._isInterstitialAdsReady}");

      // if (this._isInterstitialAdsReady) {
      //   await _interstitialAd.show();
      //   return true;
      // }

      // return false;
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          actions: [
            GestureDetector(
                onTap: () async {
                  final tempMap = args['data'];
                  tempMap['main_image_cropped'] = '';
                  print('afdsssssssssssaaaaaaaaa');
                  print(tempMap);
                  final newsData = {
                    "newsTitle": args["newsTitle"],
                    "newsURL": args["newsURL"],
                    "data": tempMap,
                  };
//! adding logic for dynamic url
                  print(newsData);
                  String url = '';
                  await generateUrl(newsData).then((value) => {
                        url = value,
                      });
                  final title =
                      "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" +
                          Uri.parse(url).toString();
                  FlutterShare.share(title: "Title", text: title);
                },
                child: Icon(Icons.share, color: Colors.white)),
            SizedBox(width: 14),
            PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    onTap: () async {
                      {
                        print("CLICLKKKKKKKEDDDD");
//                           final tempMap = args['data'] as Map<String, dynamic>;
//                           print(tempMap);
//                           tempMap['main_image_cropped'] = '';

//                           final newsData = {
//                             "newsTitle": args["newsTitle"],
//                             "newsURL": args["newsURL"],
//                             "data": tempMap
//                           };
// //! adding logic for dynamic url
//                           print(newsData);
//                           String url = '';
//                           await generateUrl(newsData).then((value) => {
//                                 url = value,
//                               });
//                           FlutterShare.share(
//                               linkUrl: url,
//                               title: "Title",
//                               text:
//                                   "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
//                           // FlutterShare.share(
//                           //     linkUrl: url,
//                           //     title:
//                           //         "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " +
//                           //             "Title",
//                           //     text: args['newsTitle'],
//                           //     chooserTitle: "इस खबर को शेयर करो.....");
                        final tempMap = args['data'];
                        tempMap['main_image_cropped'] = '';
                        print('afdsssssssssssaaaaaaaaa');
                        print(tempMap);
                        final newsData = {
                          "newsTitle": args["newsTitle"],
                          "newsURL": args["newsURL"],
                          "data": tempMap,
                        };
//! adding logic for dynamic url
                        print(newsData);
                        String url = '';
                        await generateUrl(newsData).then((value) => {
                              url = value,
                            });
                        final title =
                            "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" +
                                Uri.parse(url).toString();
                        FlutterShare.share(title: "Title", text: title);
                      }
                    },
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Share"),
                      ],
                    )),
                PopupMenuItem<int>(
                    onTap: () async {
                      print('refresh printed');
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (BuildContext context) {
                      //       return Center(
                      //         child: LinearProgressIndicator(
                      //           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      //         ),
                      //       );
                      //     });
                      setState(() {
                        showCircle = true;
                      });
                      await Future.delayed(Duration(seconds: 2));
                      setState(() {
                        showCircle = false;
                      });
                    },
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sync,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Refresh"),
                      ],
                    )),
                PopupMenuItem<int>(
                    onTap: () {
                      bool alreadyThere = false;
                      for (var i = 0; i < list.items.length; i++) {
                        final data = args['data'];
                        if (data["post_id"].toString() == list.items[i].id) {
                          alreadyThere = true;
                        }
                      }

                      if (alreadyThere == false) {
                        final item = Favourite(
                            id: args["data"]["post_id"].toString(),
                            data: args['data']);
                        print('2');
                        list.items.add(item);
                      }
                      storage.setItem('favourite_news', list.toJSONEncodable());
                      print('it\'s bookmarked');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              'बुकमार्क सुरक्षित हो गया',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                            action: SnackBarAction(
                              onPressed: () {},
                              label: 'Close',
                              textColor: Colors.white,
                            ),
                            duration: Duration(seconds: 3)),
                      );
                    },
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Add to Bookmarks"),
                      ],
                    )),
                PopupMenuItem<int>(
                    onTap: () {
                      launch(args['newsURL'].toString());
                    },
                    value: 4,
                    child: Row(
                      children: [
                        Icon(
                          Icons.open_in_browser,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Open in external browser"),
                      ],
                    )),
              ],
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: !(currentTheme == themeMode.darkMode)
              ? Colors.blue[900]
              : Colors.black,
          title: heading(
              text: args['newsTitle'].toString(),
              color: Colors.white,
              scale: 0.8,
              maxLines: 1),
        ),
      ),
      body: CustomeWebViewScreen(
            url: args['newsURL'].toString(),
          ),
    );
  }
}
