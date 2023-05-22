import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_interface.dart';
import 'package:flutter_ads_core_plugin/helpers/native_ad_container.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_params.dart';
import 'package:flutter_ads_core_plugin/helpers/yandex_helper.dart';

class AdManager implements
        AdHelper,
        IAdInterstitial,
        IAppOpen,
        INativeAd,
        IRewardedAd,
        IRewardedInterstitialAd {

  static AdHelper? _helper;

  static void setHelper(AdHelper adHelper) {
    _helper = adHelper;
  }

  @override
  void addTestIdentifiers(List<String> testIdentifiers) {
    if (_helper is AdmobHelper) {
      (_helper as AdmobHelper).addTestIdentifiers(testIdentifiers);
    }
  }

  @override
  Future<NativeAdContainer> getNativeAd(NativeAdParams params) async {
    if (_helper is AdmobHelper) {
      return (_helper as AdmobHelper).getNativeAd(params);
    }

    return NativeAdContainer(null);
  }

  @override
  Future<void> init() async {
    return _helper?.init();
  }

  @override
  Future<AppOpenAdController> preloadAppOpen(BaseAdParams params) async {
    if (_helper is AdmobHelper) {
      return (_helper as AdmobHelper).preloadAppOpen(params);
    }

    return AppOpenAdController();
  }

  @override
  void showInterstitialAd(BaseAdParams params) {
    if (_helper is AdmobHelper) {
      return (_helper as AdmobHelper).showInterstitialAd(params);
    }

    if (_helper is YandexHelper) {
      return (_helper as YandexHelper).showInterstitialAd(params);
    }
  }

  @override
  void showRewardedAd(RewardAdParams params) {
    if (_helper is AdmobHelper) {
      return (_helper as AdmobHelper).showRewardedAd(params);
    }

    if (_helper is YandexHelper) {
      return (_helper as YandexHelper).showRewardedAd(params);
    }
  }

  @override
  void showRewardedInterstitialAd(RewardAdParams params) {
    if (_helper is AdmobHelper) {
      return (_helper as AdmobHelper).showRewardedInterstitialAd(params);
    }
  }
}
