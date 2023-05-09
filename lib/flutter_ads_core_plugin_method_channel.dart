import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ads_core_plugin_platform_interface.dart';

/// An implementation of [FlutterAdsCorePluginPlatform] that uses method channels.
class MethodChannelFlutterAdsCorePlugin extends FlutterAdsCorePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ads_core_plugin');

  @override
  Future<double?> getLastNativeAdMeasureHeight(String factoryId) async {
    return methodChannel.invokeMethod<double>("getLastNativeAdMeasureHeight",
        <dynamic, dynamic>{"factoryId": factoryId});
  }

  @override
  Future<String?> getAndroidTestId() {
    return methodChannel.invokeMethod<String?>("getAndroidTestId");
  }
}
