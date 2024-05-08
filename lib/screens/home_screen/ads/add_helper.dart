import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6085133892973516/8864226870';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6085133892973516/8864226870';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6085133892973516/1971693070';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6085133892973516/1971693070';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6085133892973516/2431202895';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6085133892973516/2431202895';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}