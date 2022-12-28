import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

typedef AdLoadErrorCallback = void Function(String errorMessage);
typedef OnEarnedRewardCallback = void Function(String rewardName, int amount);

class AdmobHelper {
  static void showAdOpen(
      {required String adUnit,
      VoidCallback? onLoaded,
      int orientation = 0,
      int timeoutMillis = 5000,
      AdLoadErrorCallback? onFailedToLoad}) {
    AppOpenAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');

            ad.show();

            if (onLoaded != null) onLoaded();
          },
          onAdFailedToLoad: (error) {
            if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            } else {
              print('Ad open ad failed to load: ${error.message}');
            }
          },
        ),
        orientation: orientation);
  }

  static void showInterstitialAd(
      {required String adUnit,
      VoidCallback? onLoaded,
      int orientation = 0,
      int timeoutMillis = 5000,
      AdLoadErrorCallback? onFailedToLoad}) {
    InterstitialAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');

            ad.show();

            if (onLoaded != null) onLoaded();
          },
          onAdFailedToLoad: (error) {
            if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            } else {
              print('Ad open ad failed to load: ${error.message}');
            }
          },
        ));
  }

  static void showRewardedInterstitialAd({
    required String adUnit,
    int orientation = 0,
    int timeoutMillis = 5000,
    AdLoadErrorCallback? onFailedToLoad,
    OnEarnedRewardCallback? onEarnedReward,
    VoidCallback? onLoaded,
    VoidCallback? onImpression,
    VoidCallback? onAdClicked,
    VoidCallback? onDismissedFullScreen,
    VoidCallback? onShowedFullScreen,
    VoidCallback? onFailedToShowFullScreen,
  }) {
    RewardedInterstitialAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        rewardedInterstitialAdLoadCallback:
            RewardedInterstitialAdLoadCallback(onAdLoaded: (ad) {
          print("Rewarded Ad Loaded");

          if (onLoaded != null) onLoaded();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdClicked: (ad) {
              if (onAdClicked != null) onAdClicked();
            },
            onAdDismissedFullScreenContent: (ad) {
              if (onDismissedFullScreen != null) {
                onDismissedFullScreen();
              }
            },
            onAdShowedFullScreenContent: (ad) {
              if (onShowedFullScreen != null) {
                onShowedFullScreen();
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              if (onFailedToShowFullScreen != null) {
                onFailedToShowFullScreen();
              }
            },
            onAdImpression: (ad) {
              if (onImpression != null) onImpression();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            if (onEarnedReward != null) {
              onEarnedReward(reward.type, reward.amount.toInt());
            }
          });
        }, onAdFailedToLoad: (error) {
          if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            } else {
              print('Reward ad failed to load: ${error.message}');
            }
        }));
  }
}
