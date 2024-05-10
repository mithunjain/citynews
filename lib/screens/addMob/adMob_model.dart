class AdsModel {
  final String appName;
  final String packageName;
  final String interstitialAddId;
  final String nativeAddId;
  final String bannerAddId;
  final String rewardedAddId;
  final String rewardedInterstitialAddId;
  final String appOpenAddId;
  final String status;
  AdsModel({
    required this.appName,
    required this.packageName,
    required this.interstitialAddId,
    required this.nativeAddId,
    required this.bannerAddId,
    required this.rewardedAddId,
    required this.rewardedInterstitialAddId,
    required this.appOpenAddId,
    required this.status,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      appName: json['app_name'],
      packageName: json['package_name'],
      interstitialAddId: json['interstitial_add_id'],
      nativeAddId: json['native_add_id'],
      bannerAddId: json['banner_add_id'],
      rewardedAddId: json['rewarded_add_id'],
      rewardedInterstitialAddId: json['rewarded_interstitial_add_id'],
      appOpenAddId: json['app_open_add_id'],
      status: json['status'],
    );
  }
}