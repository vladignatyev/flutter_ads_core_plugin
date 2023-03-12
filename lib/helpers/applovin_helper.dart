import 'dart:async';

import 'package:applovin_max/applovin_max.dart';
import 'package:logger/logger.dart';

class ApplovinAd extends MaxAd {
  ApplovinAd(MaxAd maxAd)
      : super(maxAd.adUnitId, maxAd.networkName, maxAd.revenue, maxAd.creativeId,
            maxAd.dspName, maxAd.placement, maxAd.waterfall);
}

class ApplovinReward extends MaxReward {
  ApplovinReward(MaxReward maxReward) : super(maxReward.amount, maxReward.label);
}

class ApplovinListener {
  Function()? onAdLoadedCallback;
  Function(String errorMessage, int errorCode)? onAdLoadFailedCallback;
  Function()? onAdDisplayedCallback;
  Function(String errorMessage, int errorCode)? onAdDisplayFailedCallback;
  Function()? onAdClickedCallback;
  Function()? onAdHiddenCallback;

  ApplovinListener(
      {this.onAdClickedCallback,
      this.onAdLoadFailedCallback,
      this.onAdDisplayedCallback,
      this.onAdDisplayFailedCallback,
      this.onAdHiddenCallback,
      this.onAdLoadedCallback});
}

class RewardedApplovinListener extends ApplovinListener {
  Function(ApplovinReward reward)? onAdReceivedRewardCallback;
  Function(ApplovinAd ad)? onAdRevenuePaidCallback;

  RewardedApplovinListener({
    this.onAdReceivedRewardCallback,
    this.onAdRevenuePaidCallback,
    super.onAdClickedCallback,
    super.onAdLoadFailedCallback,
    super.onAdDisplayedCallback,
    super.onAdDisplayFailedCallback,
    super.onAdHiddenCallback,
    super.onAdLoadedCallback,
  });
}

class ApplovinHelper {
  static Map? configuration;

  static Future<void> init({required String sdkKey, bool verboseLogging = false}) async {
    AppLovinMAX.setVerboseLogging(verboseLogging);
    configuration = await AppLovinMAX.initialize(sdkKey);
  }

  static void showMediationDebugger() {
    AppLovinMAX.showMediationDebugger();
  }

  static bool isInitialized() {
    if (configuration != null) {
      return true;
    }

    return false;
  }

  static Map? getConfiguration() {
    return configuration;
  }

  static Future<ApplovinAd> preloadAppOpen(
      {required String adUnitId, ApplovinListener? listener}) async {
    final completer = Completer<ApplovinAd>();

    AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(onAdLoadedCallback: (ad) {
      completer.complete(ApplovinAd(ad));
      listener?.onAdLoadedCallback?.call();
    }, onAdLoadFailedCallback: (adUnitId, error) {
      Logger().e(error);
      completer.completeError(error);

      listener?.onAdLoadFailedCallback?.call(error.message, error.code);
    }, onAdDisplayedCallback: (ad) {
      listener?.onAdDisplayedCallback?.call();
    }, onAdDisplayFailedCallback: (ad, error) {
      listener?.onAdDisplayFailedCallback?.call(error.message, error.code);
    }, onAdClickedCallback: (ad) {
      listener?.onAdClickedCallback?.call();
    }, onAdHiddenCallback: (ad) {
      listener?.onAdHiddenCallback?.call();
    }));

    AppLovinMAX.loadAppOpenAd(adUnitId);

    return completer.future;
  }

  static Future<ApplovinAd> preloadInterstitialAd(
      {required String adUnitId, ApplovinListener? listener}) {
    final completer = Completer<ApplovinAd>();

    AppLovinMAX.setInterstitialListener(InterstitialListener(onAdLoadedCallback: (ad) {
      completer.complete(ApplovinAd(ad));
      listener?.onAdLoadedCallback?.call();
    }, onAdLoadFailedCallback: (adUnitId, error) {
      Logger().e(error);
      completer.completeError(error);
      listener?.onAdLoadFailedCallback?.call(error.message, error.code);
    }, onAdDisplayedCallback: (ad) {
      listener?.onAdDisplayedCallback?.call();
    }, onAdDisplayFailedCallback: (ad, error) {
      listener?.onAdDisplayFailedCallback?.call(error.message, error.code);
    }, onAdClickedCallback: (ad) {
      listener?.onAdClickedCallback?.call();
    }, onAdHiddenCallback: (ad) {
      listener?.onAdHiddenCallback?.call();
    }));

    AppLovinMAX.loadInterstitial(adUnitId);

    return completer.future;
  }

  static Future<ApplovinAd> preloadRewardedAd(
      {required String adUnitId, RewardedApplovinListener? listener}) {
    final completer = Completer<ApplovinAd>();

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
      
      onAdRevenuePaidCallback: (ad) {
      
      listener?.onAdRevenuePaidCallback?.call(ApplovinAd(ad));

    }, onAdLoadedCallback: (ad) {
      completer.complete(ApplovinAd(ad));
      listener?.onAdLoadedCallback?.call();
    }, onAdLoadFailedCallback: (adUnitId, error) {
      Logger().e(error);
      completer.completeError(error);
      listener?.onAdLoadFailedCallback?.call(error.message, error.code);
    }, onAdDisplayedCallback: (ad) {
      listener?.onAdDisplayedCallback?.call();
    }, onAdDisplayFailedCallback: (ad, error) {
      listener?.onAdDisplayFailedCallback?.call(error.message, error.code);
    }, onAdClickedCallback: (ad) {
      listener?.onAdClickedCallback?.call();
    }, onAdHiddenCallback: (ad) {
      listener?.onAdHiddenCallback?.call();
    }, onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {
      listener?.onAdReceivedRewardCallback?.call(ApplovinReward(reward));
    }));

    AppLovinMAX.loadRewardedAd(adUnitId);

    return completer.future;
  }

  static void showAppOpen({required String adUnitId}) async {
    if (await AppLovinMAX.isAppOpenAdReady(adUnitId) == true) {
      AppLovinMAX.showAppOpenAd(adUnitId);
    } else {
      Logger().e("Applovin APP OPEN AD IS NOT READY");
    }
  }

  static void showInterstitial({required String adUnitId}) async {
    if (await AppLovinMAX.isInterstitialReady(adUnitId) == true) {
      AppLovinMAX.showInterstitial(adUnitId);
    } else {
      Logger().e("Applovin INTERSTITIAL AD IS NOT READY");
    }
  }

  static void showRewarded({required String adUnitId}) async {
    if (await AppLovinMAX.isRewardedAdReady(adUnitId) == true) {
      AppLovinMAX.showRewardedAd(adUnitId);
    } else {
      Logger().e("Rewarded AD IS NOT READY");
    }
  }

  static void setHasUserConsent(bool hasUserConsent) {
    AppLovinMAX.setHasUserConsent(hasUserConsent);
  }

  static void setDoNotSell(bool doNotSell) {
    AppLovinMAX.setDoNotSell(doNotSell);
  }
}
