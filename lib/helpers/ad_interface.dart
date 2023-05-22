import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_params.dart';
import 'package:flutter_ads_core_plugin/helpers/native_ad_container.dart';


abstract class AdHelper {
  void init();
  void addTestIdentifiers(List<String> testIdentifiers);
}

abstract class IAppOpen {
  Future<void> init();
  Future<AppOpenAdController> preloadAppOpen(BaseAdParams params);
}

abstract class IAdInterstitial {
  void showInterstitialAd(BaseAdParams params);
}

abstract class INativeAd {
  Future<NativeAdContainer> getNativeAd(NativeAdParams params);
}

abstract class IRewardedAd {
  void showRewardedAd(RewardAdParams params);
}

abstract class IRewardedInterstitialAd {
  void showRewardedInterstitialAd(RewardAdParams params);
}

abstract class IBannerAd {
  Future<NativeAdContainer> getBannerAd(BaseAdParams params);
}
