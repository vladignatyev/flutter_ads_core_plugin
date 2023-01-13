import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdControllerStatus { none, loaded, error }

typedef AdControllerCallback = void Function(
    AdControllerStatus adControllerStatus);

class AdController {
  AdWithoutView? _adWithoutView;
  AdControllerCallback? _onLoadedListener;

  AdControllerStatus _status = AdControllerStatus.none;
  String? _errorMessage;

  /// Только для Rewarded Interstitial
  OnEarnedRewardCallback? onEarnedReward;

  AdController();

  void setAd(AdWithoutView ad) {
    _adWithoutView = ad;
    _status = AdControllerStatus.loaded;

    if (_onLoadedListener != null) {
      _onLoadedListener!(_status);
    }
  }

  bool isComplete() {
    if (_status != AdControllerStatus.none) return true;

    return false;
  }

  void setOnCompleteListener(AdControllerCallback callback) {
    _onLoadedListener = callback;
  }

  void setError(String error) {
    _status = AdControllerStatus.error;
    _errorMessage = error;

    if (_onLoadedListener != null) {
      _onLoadedListener!(_status);
    }
  }

  String? getError() {
    return _errorMessage;
  }

  void show() {
    if (_status == AdControllerStatus.loaded) {
      if (_adWithoutView is AppOpenAd) {
        (_adWithoutView as AppOpenAd).show();
      }

      if (_adWithoutView is InterstitialAd) {
        (_adWithoutView as InterstitialAd).show();
      }

      if (_adWithoutView is InterstitialAd) {
        (_adWithoutView as InterstitialAd).show();
      }

      if (_adWithoutView is RewardedInterstitialAd) {
        (_adWithoutView as RewardedInterstitialAd).show(
            onUserEarnedReward: (ad, reward) {
          if (onEarnedReward != null) {
            onEarnedReward!(reward.type, reward.amount.toInt());
          }
        });
      }
    } else {
      print("AD IS NOT READY!!!");
    }
  }
}