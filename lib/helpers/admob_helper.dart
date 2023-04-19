import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin_method_channel.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
import 'package:flutter_ads_core_plugin/helpers/native_ad_container.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

typedef AdLoadErrorCallback = void Function(String errorMessage);
typedef OnEarnedRewardCallback = void Function(String rewardName, int amount);

class AdmobHelper {
  static const int defaultTimeout = 15000;

  static final MethodChannelFlutterAdsCorePlugin _platform =
      MethodChannelFlutterAdsCorePlugin();

  static addTestIdentifiers(List<String> testIdentifiers) {
    MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testIdentifiers));
  }

  /// Ставить в точку входа main() приложения
  /// перед этим обязательно указать WidgetsFlutterBinding.ensureInitialized()
  /// перед runApp
  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Метод подгружает AppOpen рекламу и передает контроллер
  static Future<AppOpenAdController> preloadAppOpen(
      {required String adUnit,
      VoidCallback? onAdLoaded,
      int orientation = 0,
      int timeoutMillis = defaultTimeout,
      AdLoadErrorCallback? onFailedToLoad}) async {
    var completer = Completer<AppOpenAdController>();
    AppOpenAdController controller = AppOpenAdController();

    Timer timeoutTimer = Timer(Duration(milliseconds: timeoutMillis + 500), () {
      controller.setError("Timeout");
      Logger().d('AppOpen Ad skipped by timeout');
      completer.complete(controller);
    });

    AppOpenAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            timeoutTimer.cancel();
            Logger().d('AppOpen loaded');

            controller.setAd(ad);

            if (onAdLoaded != null) onAdLoaded();

            completer.complete(controller);
          },
          onAdFailedToLoad: (error) {
            timeoutTimer.cancel();
            Logger().e('Ad open ad failed to load: ${error.message}');

            controller.setError(error.message);

            if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            }

            completer.complete(controller);
          },
        ),
        orientation: orientation);

    return completer.future;
  }

  static Future<NativeAdContainer> getNativeAd(
      {required String adUnitId,
      required CustomOptions customOptions,
      int timeoutMillis = defaultTimeout,
      OnAdFailedToLoadCallback? onAdFailedToLoad,
      required String nativeAdFactory}) {
    var completer = Completer<NativeAdContainer>();

    Map<String, Object> options = customOptions.convertToMap();

    Timer timeoutTimer = Timer(Duration(milliseconds: timeoutMillis + 500), () {
      Logger().d('Native ad request skipped by timeout');
      completer.complete(NativeAdContainer(null));
    });

    NativeAd(
            nativeAdOptions: NativeAdOptions(
                videoOptions: VideoOptions(
                    startMuted: true,
                    customControlsRequested: false,
                    clickToExpandRequested: false)),
            adUnitId: adUnitId,
            customOptions: options,
            factoryId: nativeAdFactory,
            listener: NativeAdListener(
              onAdFailedToLoad: (ad, error) {
                timeoutTimer.cancel();
                Logger().e("Native ad failed load: ${error.message}");

                if (onAdFailedToLoad != null) {
                  onAdFailedToLoad(error.toString());
                }

                completer.complete(NativeAdContainer(null));
              },
              onAdLoaded: (ad) async {
                Logger().d("Native ad loaded");
                timeoutTimer.cancel();

                AdWidget.optOutOfVisibilityDetectorWorkaround = true;

                double? height = await _platform
                    .getLastNativeAdMeasureHeight(nativeAdFactory);

                Logger().d("Measure height = $height px");

                height = (height ?? 0) /
                    MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                        .devicePixelRatio;

                completer.complete(NativeAdContainer(SizedBox(
                    height: height, child: AdWidget(ad: ad as AdWithView))));
              },
            ),
            request: AdRequest(httpTimeoutMillis: timeoutMillis))
        .load();

    return completer.future;
  }

  static void showInterstitialAd(
      {required String adUnit,
      VoidCallback? onLoaded,
      int orientation = 0,
      int timeoutMillis = defaultTimeout,
      AdLoadErrorCallback? onFailedToLoad}) {
    InterstitialAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            Logger().d('Intertitial ad loaded');

            ad.show();

            if (onLoaded != null) onLoaded();
          },
          onAdFailedToLoad: (error) {
            if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            }

            Logger().e('Intertitial ad failed to load: ${error.message}');
          },
        ));
  }

  static void showRewardedInterstitialAd({
    required String adUnit,
    int orientation = 0,
    int timeoutMillis = defaultTimeout,
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
          Logger().d("Rewarded Ad Loaded");

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
            Logger().e('Reward ad failed to load: ${error.message}');
          }
        }));
  }

  static void showRewardedAd({
    required String adUnit,
    int orientation = 0,
    int timeoutMillis = defaultTimeout,
    AdLoadErrorCallback? onFailedToLoad,
    OnEarnedRewardCallback? onEarnedReward,
    VoidCallback? onLoaded,
    VoidCallback? onImpression,
    VoidCallback? onAdClicked,
    VoidCallback? onDismissedFullScreen,
    VoidCallback? onShowedFullScreen,
    VoidCallback? onFailedToShowFullScreen,
  }) {
    RewardedAd.load(
      adUnitId: adUnit,
      request: AdRequest(httpTimeoutMillis: timeoutMillis),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        Logger().d("Rewarded Ad Loaded");

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
          Logger().e('Reward ad failed to load: ${error.message}');
        }
      }),
    );
  }
}
