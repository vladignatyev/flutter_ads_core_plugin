import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ads_core_plugin/helpers/ad_controller.dart';
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
  static Future<void> requestConsentInfo(
      {bool debugMode = false,
      bool forcedMode = false,
      Function? onCompleteCallback,
      List<String>? testIdentifiers}) async {
    ConsentInformation.instance.reset();

    ConsentDebugSettings debugSettings = ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: testIdentifiers);

    final paramsForDebugMode =
        ConsentRequestParameters(consentDebugSettings: debugSettings);

    final paramsForStandartMode = ConsentRequestParameters();

    Completer completer = Completer();

    ConsentInformation.instance.requestConsentInfoUpdate(
        debugMode ? paramsForDebugMode : paramsForStandartMode, () async {
      ConsentInformation.instance
          .isConsentFormAvailable()
          .then((isAvailable) async {
        if (!isAvailable) {
          completer.complete();
          return;
        }

        if (forcedMode) {
          await _showConsentForm();
        } else {
          // проверка на то что разрешение уже получено
          if (await ConsentInformation.instance.getConsentStatus() ==
              ConsentStatus.obtained) {
            completer.complete();
          }
        }

        if (onCompleteCallback != null) {
          _waitConsentFormComplete(onCompleteCallback);
        }
      }).onError((error, stackTrace) {
        print(error);
      }).timeout(const Duration(seconds: 3));
    }, (error) {
      print("ERROR");
      print(error.message);

      completer.complete();
    });

    return completer.future;
  }

  static void _waitConsentFormComplete(Function callback) async {
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
      _waitConsentFormComplete(callback);
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

  static void showAdOpen(
      {required String adUnit,
      VoidCallback? onLoaded,
      int orientation = 0,
      int timeoutMillis = 5000,

      /// Если указан контроллер, то показ рекламы запускается через него
      AdController? controller,
      AdLoadErrorCallback? onFailedToLoad}) {
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
