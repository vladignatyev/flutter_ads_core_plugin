import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

enum ConsentInfoReason { notRequired, obtained }

/// Запрос разрешения на сбор личных данных для рекламы (только Евросоюз)
/// forcedMode - значит что запрашивать каждый раз
/// debugMode - режим тестирования, при этом принудительно присваивается регион ЕС
class RequestConsent {
  final bool debugMode;
  final bool forcedMode;
  final VoidCallback? onCompleteCallback;
  final List<String>? testIdentifiers;
  ConsentRequestParameters _consentRequestParameters = ConsentRequestParameters();

  RequestConsent(
      {this.debugMode = false,
      this.forcedMode = false,
      this.onCompleteCallback,
      this.testIdentifiers}) {
    if (forcedMode) resetConsent();
    if (debugMode) _setDebugMode();
  }

  Future<ConsentInfoReason> complete() async {
    final completer = Completer<ConsentInfoReason>();
    await _consentUpdate(completer);
    return completer.future;
  }

  Future<ConsentInfoReason> _consentUpdate(Completer<ConsentInfoReason> completer) async {
    ConsentInformation.instance.requestConsentInfoUpdate(_consentRequestParameters,
        () async {
      // Консент недоступен - завершение комплита
      if (await _requestConsentAvailable() == false) {
        completer.complete(ConsentInfoReason.notRequired);
        return;
      }

      ConsentStatus consentStatus = await _requestConsentStatus();
      Logger().d("Consent status is $consentStatus");
      
      switch (consentStatus) {
        case ConsentStatus.notRequired:          
          completer.complete(ConsentInfoReason.notRequired);
          break;

        case ConsentStatus.obtained:
          completer.complete(ConsentInfoReason.obtained);
          break;

        case ConsentStatus.required:
          try {            
            /// завершается данный вызов только после того
            /// как форма по той или ной причине закрыта
            /// Complete на OnConsentFormDismissedListener
            await _showAndCompleteConsentForm();


            /// вне зависимости от результата вызываем рекурсивно метод
            /// если была ошибка при загрузке формы (но форма при этом доступна)
            /// или если юзер нажал согласие
            /// передаем экземпляр комплитера из данного вызова
            _consentUpdate(completer);

          } catch (error) {
            
            /// вызывается в случае OnConsentFormLoadFailureListener
            /// завершаем комплитер текущего метода (_consentUpdate)
            completer.completeError(error);
          }

          break;

        /// такой статус появляется если метод SDK выдал некорректный статус
        case ConsentStatus.unknown:
          Logger().wtf("Consent status is UNKNOWN");
          completer.complete(ConsentInfoReason.notRequired);
          break;
      }
    }, (error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<void> _showAndCompleteConsentForm() async {
    final completer = Completer();

    ConsentForm.loadConsentForm((consentForm) {
      consentForm.show((formError) {
        if (formError != null) {
          Logger().e(formError.message);
        }

        /// завершение комплитера на закрытие 
        /// формы неважно по какой причине
        completer.complete();
      });
    }, (formError) {
      Logger().e(formError.message);
      completer.completeError(formError);
    });

    return completer.future;
  }

  Future<ConsentStatus> _requestConsentStatus() async {
    return ConsentInformation.instance.getConsentStatus();
  }

  Future<bool> _requestConsentAvailable() async {
    return ConsentInformation.instance.isConsentFormAvailable();
  }

  /// метод сделал статическим чтобы мы могли при необходимости
  /// вызывать его из клиентского кода
  static void resetConsent() {
    ConsentInformation.instance.reset();
  }

  void _setDebugMode() {
    _consentRequestParameters = ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
            debugGeography: DebugGeography.debugGeographyEea,
            testIdentifiers: testIdentifiers));
  }
}
