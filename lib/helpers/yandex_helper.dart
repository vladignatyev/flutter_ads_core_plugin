import 'dart:ui';
import 'package:flutter_ads_core_plugin/helpers/ad_interface.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_params.dart';
import 'package:logger/logger.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class YandexHelper extends AdHelper implements IAdInterstitial, IRewardedAd {

  static const int defaultTimeout = 15000;

  @override
  void init() async {
    await MobileAds.initialize();    
  }

  @override
  void showInterstitialAd(BaseAdParams params) async {
    final adInstance = await InterstitialAd.create(
      adUnitId: params.adUnit,
      onAdLoaded: () {
        Logger().d('Intertitial ad from ${runtimeType.toString()} loaded');
        params.onAdLoaded?.call();
      },
      onAdFailedToLoad: (error) {
        Logger().e(
            'Intertitial ad from ${runtimeType.toString()} failed to load: ${error.description}');
        params.onFailedToLoad?.call(error.description);
      },
    );

    await adInstance.load(adRequest: const AdRequest());
    await adInstance.show();
  }

  @override
  void showRewardedAd(RewardAdParams params) async {
    final adInstance = await RewardedAd.create(
      adUnitId: params.adUnit,
      onAdLoaded: () {
        Logger().d('Rewarded ad from ${runtimeType.toString()} loaded');
        params.onAdLoaded?.call();
      },
      onAdFailedToLoad: (error) {
        Logger().e(
            'Rewarded ad from ${runtimeType.toString()} failed to load: ${error.description}');
        params.onFailedToLoad?.call(error.description);
      },
      onRewarded: (reward) {
        params.onEarnedReward?.call(reward.type, reward.amount);
      },
      onImpression: (impressionData) => params.onImpression?.call(),
      onAdClicked: () => params.onAdClicked?.call(),
      onAdDismissed: () => params.onDismissedFullScreen?.call(),
      onAdShown: () => params.onShowedFullScreen?.call(),
      onLeftApplication: () => params.onFailedToShowFullScreen?.call(),
    );

    await adInstance.load(adRequest: const AdRequest());
    await adInstance.show();
  }
  
  @override
  void addTestIdentifiers(List<String> testIdentifiers) {
    //
  }

}
