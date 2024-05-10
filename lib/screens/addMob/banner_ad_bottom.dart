import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/screens/addMob/admob_ids.dart';

class BottomBannerAdmob extends StatefulWidget {
  const BottomBannerAdmob({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BannerAdmobState();
  }
}

class _BannerAdmobState extends State<BottomBannerAdmob> {
  late BannerAd _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();
    loadAdData();
  }

  loadAdData() {
    final adUnitId = AdMobIds.bannerIdAndroid;
    debugPrint('ad unit id:$adUnitId');
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
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
    _bannerAd.load();
    debugPrint('ad unit id loaded:$adUnitId ,$_bannerReady');
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
        : Padding(
            padding: const EdgeInsets.only(top: .0),
            child: Container(
              //padding: const EdgeInsets.only(bottom: 10),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 8, bottom: 10),
              child: SizedBox(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: const Center(
                  child: Text(
                    '🎟   Advertisement',
                  ),
                ),
              ),
            ));
  }
}

class BottomBannerAdmob1 extends StatefulWidget {
  const BottomBannerAdmob1({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BannerAdmobState1();
  }
}

class _BannerAdmobState1 extends State<BottomBannerAdmob1> {
  late BannerAd _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();
    loadAdData();
  }

  loadAdData() {
   
    final adUnitId = AdMobIds.bannerIdAndroid;
    debugPrint('ad unit id:$adUnitId');
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
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
    _bannerAd.load();
    debugPrint('ad unit id loaded:$adUnitId ,$_bannerReady');
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
        : const SizedBox();
  }
}
