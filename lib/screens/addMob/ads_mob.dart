import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper extends ChangeNotifier {
  // TODO : this is real id
  // static final String _bannerIdAndroid = adsModel?.bannerAddId ?? '';
  // static const _bannerIdIos = 'ca-app-pub-3399341013866982/6491749287';

  // static const _interstitialIdAndroid =
  //     'ca-app-pub-6091648454963684/4908757570';
  // static const _interstitialIdIos = 'ca-app-pub-3399341013866982/9911301302';

  // static const _nativeIdAndroid = 'ca-app-pub-3399341013866982/6427575928';
  // static const _nativeIdIos = 'ca-app-pub-3399341013866982/8849447179';

  // static const _appOpenIdAndroid = 'ca-app-pub-3399341013866982/8573388032';
  // static const _appOpenIdIos = 'ca-app-pub-3399341013866982/8573388032';

  // static const _interstitialvideoIdAndroid =
  //     'ca-app-pub-6091648454963684/4908757570';
  // static const _interstitialvideoIdIos =
  //     'ca-app-pub-3399341013866982/9911301302';

  // TODO : this is test id

  static const _bannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _bannerIdIos = 'ca-app-pub-3940256099942544/6300978111';

  static const _interstitialIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const _interstitialIdIos = 'ca-app-pub-3940256099942544/1033173712';

  static const _nativeIdAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const _nativeIdIos = 'ca-app-pub-3940256099942544/2247696110';

  static const _appOpenIdAndroid = 'ca-app-pub-3940256099942544/3419835294';
  static const _appOpenIdIos = 'ca-app-pub-3940256099942544/3419835294';

  static const _interstitialvideoIdAndroid =
      'ca-app-pub-3940256099942544/8691691433';
  static const _interstitialvideoIdIos =
      'ca-app-pub-3940256099942544/8691691433';

  InterstitialAd? _interstitialAd;
  final int maxFailedLoadAttempts = 3;
  int _currBannerIndex = -1;

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return _appOpenIdAndroid;
    } else if (Platform.isIOS) {
      return _appOpenIdIos;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _bannerIdAndroid;
    } else if (Platform.isIOS) {
      return _bannerIdIos;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialvideoAdUnitId {
    if (Platform.isAndroid) {
      return _interstitialvideoIdAndroid;
    } else if (Platform.isIOS) {
      return _interstitialvideoIdIos;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _interstitialIdAndroid;
    } else if (Platform.isIOS) {
      return _interstitialIdIos;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return _nativeIdAndroid;
    } else if (Platform.isIOS) {
      return _nativeIdIos;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  getInlineBanner(int maxIndex) {
    _currBannerIndex++;
    if (_currBannerIndex > maxIndex) _currBannerIndex = 0;
    return _currBannerIndex;
  }

  int _interstitialLoadAttempts = 0;

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  // ignore: recursive_getters
  get interstitialAd => interstitialAd!;

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      // DataManagement.storeAdData(StoredString.isSeriesAdDisplayed, true);
    }
  }

  interstitialAdDispose() {
    _interstitialAd!.dispose();
  }
}
