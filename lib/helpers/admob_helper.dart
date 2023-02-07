import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads_core_plugin/flutter_ads_core_plugin.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
import 'package:flutter_ads_core_plugin/helpers/native_ad_container.dart';
import 'package:flutter_ads_core_plugin/shared/custom_options.dart';
import 'package:flutter_ads_core_plugin/shared/view_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

typedef AdLoadErrorCallback = void Function(String errorMessage);
typedef OnEarnedRewardCallback = void Function(String rewardName, int amount);

class AdmobHelper {
  static bool _waitStopperFlag = false;
  static void stopWaitFunctions() {
    _waitStopperFlag = true;
  }

  /// Ставить в точку входа main() приложения
  /// перед этим обязательно указать WidgetsFlutterBinding.ensureInitialized()
  /// перед runApp
  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Запрос разрешения на сбор личных данных для рекламы (только Евросоюз)
  /// forcedMode - значит что запрашивать каждый раз
  /// debugMode - режим тестирования, при этом принудительно присваивается регион ЕС
  static void requestConsentInfo(
      {bool debugMode = false,
      bool forcedMode = false,
      Function? onCompleteCallback,
      List<String>? testIdentifiers}) async {
    
    if (forcedMode) ConsentInformation.instance.reset();

    ConsentDebugSettings debugSettings = ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: testIdentifiers);

    final paramsForDebugMode =
        ConsentRequestParameters(consentDebugSettings: debugSettings);

    final paramsForStandartMode = ConsentRequestParameters();

    

    ConsentInformation.instance.requestConsentInfoUpdate(
        debugMode ? paramsForDebugMode : paramsForStandartMode, () async {


      ConsentInformation.instance
          .isConsentFormAvailable()
          .then((isAvailable) async {

        if (!isAvailable) {
          if (onCompleteCallback != null) onCompleteCallback();
          return;
        }

        if (forcedMode) {
          await _showConsentForm();
        } else {
          // проверка на то что разрешение уже получено
          if (await ConsentInformation.instance.getConsentStatus() ==
              ConsentStatus.obtained) {
            if (onCompleteCallback != null) onCompleteCallback();
            return;
          }
        }

        if (onCompleteCallback != null) {
          _pollingConsentFormComplete(onCompleteCallback);
        }

      }).onError((error, stackTrace) {
        print(error);
      }).timeout(const Duration(seconds: 3));
    }, (error) {
      print("ERROR");
      print(error.message);
    });
  }

  static void _pollingConsentFormComplete(Function callback) async {
    if (_waitStopperFlag == true) {
      _waitStopperFlag = false;
      return;
    }

    print(await ConsentInformation.instance.getConsentStatus());

    if (await ConsentInformation.instance.getConsentStatus() ==
        ConsentStatus.obtained) {
      callback();
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      _pollingConsentFormComplete(callback);
    }
  }

  static Future<void> _showConsentForm() async {
    Completer completer = Completer();

    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        consentForm.show((formError) {
          print(formError?.message);
        });

        completer.complete();
      },
      (FormError formError) {
        print(formError.message);

        completer.completeError(formError);
      },
    );

    return completer.future;
  }

  static Future<void> showAdOpen(
      {required String adUnit,
      VoidCallback? onLoaded,
      int orientation = 0,
      int timeoutMillis = 5000,

      /// Если указан контроллер, то показ рекламы запускается через него
      AdController? controller,
      AdLoadErrorCallback? onFailedToLoad}) async {
    var completer = Completer();

    var timeOutTimer = Timer(Duration(milliseconds: timeoutMillis), () {
      if (controller != null) {
        controller.setError("Timeout");
      }

      completer.complete();
    });

    AppOpenAd.load(
        adUnitId: adUnit,
        request: AdRequest(httpTimeoutMillis: timeoutMillis),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');

            if (controller != null) {
              controller.setAd(ad);
            } else {
              ad.show();
            }

            if (onLoaded != null) onLoaded();

            completer.complete();
            timeOutTimer.cancel();
          },
          onAdFailedToLoad: (error) {
            if (controller != null) {
              controller.setError(error.message);
            }

            if (onFailedToLoad != null) {
              onFailedToLoad(error.message);
            } else {
              print('Ad open ad failed to load: ${error.message}');
            }

            completer.complete();
            timeOutTimer.cancel();
          },
        ),
        orientation: orientation);

    return completer.future;
  }

  static Future<dynamic> getNativeAd(
      {required String adUnitId,
      required CustomOptions customOptions,
      int timeout = 5000,
      required String nativeAdFactory}) {
    var completer = Completer();

    Map<String, Object> options = customOptions.convertToMap();

    var timeoutTimer = Timer(Duration(milliseconds: timeout), () {
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
                print(error);
                completer.complete(NativeAdContainer(null));
                timeoutTimer.cancel();
              },
              onAdLoaded: (ad) {
                completer.complete(NativeAdContainer(SizedBox(
                    height: ViewOptions.getOptions(nativeAdFactory).height,
                    child: AdWidget(ad: ad as AdWithView))));

                timeoutTimer.cancel();
              },
            ),
            request: const AdRequest())
        .load();

    return completer.future;
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
