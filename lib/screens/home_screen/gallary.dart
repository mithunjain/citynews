import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/topbar_categories.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/styles.dart';
import 'package:provider/provider.dart';
import '../bookmark_page.dart';
import 'ads/add_helper.dart';

class Gallery extends StatefulWidget {
  Gallery(this.scrollController, this.cp, this.pageTitle, {Key? key})
      : super(key: key);
  int cp;
  final ScrollController scrollController;
  final String pageTitle;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  //ScrollController _scrollController = ScrollController();


  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    _bannerAd = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize(
            width: MediaQuery.of(context).size.width.truncate(), height: 60),
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();

    return Scaffold(
      // bottomSheet: Container(
      //   height: 60,
      //   width: MediaQuery.of(context).size.width,
      //   child: AdWidget(ad: _bannerAd),
      // ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // brightness: Brightness.dark,
        backgroundColor: Colors.blue[900],
        // !(currentTheme == themeMode.darkMode)
        //     ? Colors.blue[900]
        //     : Colors.black,
        title: heading(text: "${widget.pageTitle}", color: Colors.white),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Icon(
                Icons.search,
              )),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LiveTVScreen()));
              },
              child: Icon(Icons.tv)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RadioScreen()));
              },
              child: Icon(Icons.radio)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookmarkPage()));
              },
              child: Icon(Icons.bookmark)),
          SizedBox(width: 10),
          Icon(Icons.notifications),
        ],
      ),
      body: Container(
          color: (currentTheme == themeMode.darkMode)
              ? Colors.black
              : Colors.white,
          child: TopBarCategory( cpId: widget.cp)),
    );
  }
}
