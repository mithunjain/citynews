import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/screens/addMob/admob_ids.dart';

class BannerAdmob extends StatefulWidget {
  const BannerAdmob({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BannerAdmobState();
  }
}

class _BannerAdmobState extends State<BannerAdmob> {
  late BannerAd _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();
    final adUnitId = AdMobIds.bannerIdAndroid;
    debugPrint('ad unit id:$adUnitId');
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _bannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          setState(() {
            _bannerReady = false;
          });
          ad.dispose();
        },
      ),
    );
    // debugPrint('Banner ad Loaded:$_bannerReady id:$adUnitId');
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerReady
        ? Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 10),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          )
        : Container();
    // Padding(
    //     padding: const EdgeInsets.only(top: .0),
    //     child: Container(
    //       //padding: const EdgeInsets.only(bottom: 10),
    //       margin: const EdgeInsets.only(
    //           left: 10, right: 10, top: 8, bottom: 10),
    //       child: SizedBox(
    //         width: _bannerAd.size.width.toDouble(),
    //         height: _bannerAd.size.height.toDouble(),
    //         child: const Center(
    //           child: Text(
    //             '🎟   Advertisement',
    //           ),
    //         ),
    //       ),
    //     ))
  }
}
