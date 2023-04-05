import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ads_core_plugin_method_channel.dart';

abstract class FlutterAdsCorePluginPlatform extends PlatformInterface {
  /// Constructs a FlutterAdsCorePluginPlatform.
  FlutterAdsCorePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAdsCorePluginPlatform _instance =
      MethodChannelFlutterAdsCorePlugin();

  /// The default instance of [FlutterAdsCorePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAdsCorePlugin].
  static FlutterAdsCorePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAdsCorePluginPlatform] when
  /// they register themselves.
  static set instance(FlutterAdsCorePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<double?> getLastNativeAdMeasureHeight(String factoryId);
}
