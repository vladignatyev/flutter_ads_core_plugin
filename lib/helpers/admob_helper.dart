import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin_method_channel.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_interface.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_params.dart';
import 'package:flutter_ads_core_plugin/helpers/native_ad_container.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdmobHelper extends AdHelper
    implements IAdInterstitial, IAppOpen, INativeAd, IRewardedAd, IRewardedInterstitialAd {
  static const int defaultTimeout = 15000;

  static final MethodChannelFlutterAdsCorePlugin _platform = MethodChannelFlutterAdsCorePlugin();

  @override
  void addTestIdentifiers(List<String> testIdentifiers) {
    MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(testDeviceIds: testIdentifiers));
  }

  /// Ставить в точку входа main() приложения
  /// перед этим обязательно указать WidgetsFlutterBinding.ensureInitialized()
  /// перед runApp
  @override
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Метод подгружает AppOpen рекламу и передает контроллер
  @override
  Future<AppOpenAdController> preloadAppOpen(BaseAdParams params) async {
    var completer = Completer<AppOpenAdController>();
    AppOpenAdController controller = AppOpenAdController();

    Timer timeoutTimer = Timer(Duration(milliseconds: params.timeoutMillis + 500), () {
      controller.setError("Timeout");
      Logger().d('AppOpen Ad from ${runtimeType.toString()} skipped by timeout');
      completer.complete(controller);
    });

    AppOpenAd.load(
        adUnitId: params.adUnit,
        request: AdRequest(httpTimeoutMillis: params.timeoutMillis),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            timeoutTimer.cancel();
            Logger().d('AppOpen from ${runtimeType.toString()} loaded');

            controller.setAd(ad);

            params.onAdLoaded?.call();

            completer.complete(controller);
          },
          onAdFailedToLoad: (error) {
            timeoutTimer.cancel();
            Logger()
                .e('AppOpen ad from ${runtimeType.toString()} failed to load: ${error.message}');

            controller.setError(error.message);

            params.onFailedToLoad?.call(error.message);

            completer.complete(controller);
          },
        ),
        orientation: 0);

    return completer.future;
  }

  @override
  Future<NativeAdContainer> getNativeAd(NativeAdParams params) {
    var completer = Completer<NativeAdContainer>();

    Map<String, Object> options = params.customOptions.convertToMap();

    Timer timeoutTimer = Timer(Duration(milliseconds: params.timeoutMillis + 500), () {
      Logger().d('Native ad from ${runtimeType.toString()} request skipped by timeout');
      completer.complete(NativeAdContainer(null));
    });

    NativeAd(
            nativeAdOptions: NativeAdOptions(              
                videoOptions: VideoOptions(
                    startMuted: false,
                    customControlsRequested: false,
                    clickToExpandRequested: false)),
            adUnitId: params.adUnit,
            customOptions: options,
            factoryId: params.nativeAdFactory,
            listener: NativeAdListener(
              onAdFailedToLoad: (ad, error) {
                timeoutTimer.cancel();
                Logger()
                    .e("Native ad from ${runtimeType.toString()} failed load: ${error.message}");

                params.onFailedToLoad?.call(error.message);

                completer.complete(NativeAdContainer(null));
              },
              onAdLoaded: (ad) async {
                Logger().d("Native ad from ${runtimeType.toString()} loaded");
                timeoutTimer.cancel();

                AdWidget.optOutOfVisibilityDetectorWorkaround = true;

                double? height =
                    await _platform.getLastNativeAdMeasureHeight(params.nativeAdFactory);

                Logger().d("Measure height = $height px");

                height = (height ?? 0) /
                    MediaQueryData.fromWindow(WidgetsBinding.instance.window).devicePixelRatio;

                completer.complete(NativeAdContainer(
                    SizedBox(height: height, child: AdWidget(ad: ad as AdWithView))));
              },
            ),
            request: AdRequest(httpTimeoutMillis: params.timeoutMillis))
        .load();

    return completer.future;
  }

  @override
  void showInterstitialAd(BaseAdParams params) {
    InterstitialAd.load(
        adUnitId: params.adUnit,
        request: AdRequest(httpTimeoutMillis: params.timeoutMillis),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            Logger().d('Intertitial ad from ${runtimeType.toString()} loaded');

            ad.show();

            params.onAdLoaded?.call();
          },
          onAdFailedToLoad: (error) {
            params.onFailedToLoad?.call(error.message);

            Logger().e(
                'Intertitial ad from ${runtimeType.toString()} failed to load: ${error.message}');
          },
        ));
  }

  @override
  void showRewardedInterstitialAd(RewardAdParams params) {
    RewardedInterstitialAd.load(
        adUnitId: params.adUnit,
        request: AdRequest(httpTimeoutMillis: params.timeoutMillis),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(onAdLoaded: (ad) {
          Logger().d("Rewarded Ad from ${runtimeType.toString()} Loaded");

          params.onAdLoaded?.call();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdClicked: (ad) {
              params.onAdClicked?.call();
            },
            onAdDismissedFullScreenContent: (ad) {
              params.onDismissedFullScreen?.call();
            },
            onAdShowedFullScreenContent: (ad) {
              params.onShowedFullScreen?.call();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              params.onFailedToShowFullScreen?.call();
            },
            onAdImpression: (ad) {
              params.onImpression?.call();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            params.onEarnedReward?.call(reward.type, reward.amount.toInt());
          });
        }, onAdFailedToLoad: (error) {
          params.onFailedToLoad?.call(error.message);
          Logger().e('Reward ad from ${runtimeType.toString()} failed to load: ${error.message}');
        }));
  }

  @override
  void showRewardedAd(RewardAdParams params) {
    RewardedAd.load(
      adUnitId: params.adUnit,
      request: AdRequest(httpTimeoutMillis: params.timeoutMillis),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        Logger().d("Rewarded Ad from ${runtimeType.toString()} Loaded");

        params.onAdLoaded?.call();

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdClicked: (ad) => params.onAdClicked?.call(),
          onAdDismissedFullScreenContent: (ad) => params.onDismissedFullScreen?.call(),
          onAdShowedFullScreenContent: (ad) => params.onShowedFullScreen?.call(),
          onAdFailedToShowFullScreenContent: (ad, error) => params.onFailedToShowFullScreen?.call(),
          onAdImpression: (ad) => params,
        );
        ad.show(onUserEarnedReward: (ad, reward) {
          params.onEarnedReward?.call(reward.type, reward.amount.toInt());          
        });
      }, onAdFailedToLoad: (error) {
          params.onFailedToLoad?.call(error.message);
          Logger().e('Reward ad from ${runtimeType.toString()} failed to load: ${error.message}');
      }),
    );
  }
}
