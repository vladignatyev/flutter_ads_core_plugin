import 'package:flutter/foundation.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';

typedef AdErrorCallback = void Function(String errorMessage);
typedef OnEarnedRewardCallback = void Function(String rewardName, int amount);

class BaseAdParams {
  final String adUnit;
  final int timeoutMillis;
  final VoidCallback? onAdLoaded;
  final AdErrorCallback? onFailedToLoad;
  final ChangeNotifier? listener;
  BaseAdParams(
      {this.onAdLoaded, this.onFailedToLoad, required this.adUnit, required this.timeoutMillis, this.listener});
}

class NativeAdParams extends BaseAdParams {
  final CustomOptions customOptions;
  final String nativeAdFactory;

  NativeAdParams(
      {required this.customOptions,
      required this.nativeAdFactory,
      required super.adUnit,
      required super.timeoutMillis,
      super.listener,
      super.onFailedToLoad,
      super.onAdLoaded});
}

class RewardAdParams extends BaseAdParams {
  final OnEarnedRewardCallback? onEarnedReward;
  final VoidCallback? onImpression;
  final VoidCallback? onAdClicked;
  final VoidCallback? onDismissedFullScreen;
  final VoidCallback? onShowedFullScreen;
  final VoidCallback? onFailedToShowFullScreen;

  RewardAdParams(
      {this.onEarnedReward,
      this.onImpression,
      this.onAdClicked,
      this.onDismissedFullScreen,
      this.onShowedFullScreen,
      this.onFailedToShowFullScreen,
      super.onAdLoaded,
      super.onFailedToLoad,
      super.listener,
      required super.adUnit,
      required super.timeoutMillis});
}
