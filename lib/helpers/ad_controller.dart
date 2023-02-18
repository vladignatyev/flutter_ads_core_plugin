import 'package:flutter/animation.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

enum AdControllerStatus { none, loaded, error }

typedef AdControllerCallback = void Function(
    AdControllerStatus adControllerStatus);

abstract class AdController {  
  AdWithoutView? _adWithoutView;
  AdControllerStatus _status = AdControllerStatus.none;
  String? _errorMessage;

  void setAd(AdWithoutView ad);

  String? getErrorMessage() {
    return _errorMessage;
  }

  bool isLoaded() {
    if (_status == AdControllerStatus.loaded) {
      return true;
    } else {
      return false;
    }
  }

  void setError(String error) {
    _status = AdControllerStatus.error;
    _errorMessage = error;
  }

  void show();
}

class AppOpenAdController extends AdController {
  VoidCallback? onAdShowedFullScreenContent;
  VoidCallback? onImpression;
  VoidCallback? onAdClicked;
  VoidCallback? onDismissedFullScreen;
  VoidCallback? onShowedFullScreen;
  VoidCallback? onFailedToShowFullScreen;

  AppOpenAdController();

  @override
  void setAd(AdWithoutView ad) {
    (ad as AppOpenAd).fullScreenContentCallback = FullScreenContentCallback(
      onAdClicked: (ad) {
        if (onAdClicked != null) onAdClicked!();
      },
      onAdDismissedFullScreenContent: (ad) {
        if (onDismissedFullScreen != null) {
          onDismissedFullScreen!();
        }
      },
      onAdShowedFullScreenContent: (ad) {
        if (onShowedFullScreen != null) {
          onShowedFullScreen!();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (onFailedToShowFullScreen != null) {
          onFailedToShowFullScreen!();
        }
      },
      onAdImpression: (ad) {
        if (onImpression != null) onImpression!();
      },
    );
    _adWithoutView = ad;
    _status = AdControllerStatus.loaded;
  }

  @override
  void show() {
    if (_status == AdControllerStatus.loaded) {
      (_adWithoutView as AppOpenAd).show();
    } else {
      Logger().d("AppOpenAd is not loaded");
    }
  }
}
